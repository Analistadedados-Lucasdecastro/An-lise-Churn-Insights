create database projeto_churn;
use projeto_churn;
select * from clientes_telco;
-- primeiro, desativarei a trava de segurança para efetuar a limpeza corretamente

SET SQL_SAFE_UPDATES = 0;
-- depois, vou trocar qualquer espaço vazio no "TotalCharges" (Total gasto do cliente com a empresa) para 0 onde o valor for vazio 

update clientes_telco
set TotalCharges = '0'
where TotalCharges = ' ' or TotalCharges = '';

-- Agora eu vou tranformar essa coluna em 'Decimal' para que eu faça os cálculos financeiros da melhor forma possível

alter table clientes_telco
modify TotalCharges decimal(10,2);

-- Agora eu vou descobrir a Taxa de Churn dos clientes

select 
  churn, count(*) as total_clientes,
  round((count(*) * 100.0 / (select count(*) from clientes_telco)), 2) as porcentagem
  from clientes_telco
  group by churn;
  
  -- Com isso percebe-se uma taxa de churn de aproximadamente 26% (1869 churns), visto que temos contratos mensais e anuais, é interessante checar de qual dos contratos mais temos churn
  
  select
    contract,
    churn,
    count(*) as total from clientes_telco
    group by contract, churn
    order by contract;
    
    -- Analisando as saídas dos diferentes tipos de contrato, percebe-se que há menos saídas em contratos anuais, com uma taxa de churn bem maior no mensal
    -- Com essa conclusão, vemos que é mais interessante focar em contratos anuais e fazer campanhas para converter para anuais os clientes mensais.

-- Outra coisa que podemos analisar para tirarmos insights valiosos é se a média da mensalidade influencia nesses churns

select 
    churn,
    round(avg(MonthlyCharges), 2) as media_mensalidade 
    from clientes_telco
    group by churn;
    
-- Com isso notamos que os clientes com uma mensalidade média de até R$61,00 normalmente não se tornam churn, porém clientes com uma média de até R$74,44 são em sua MAIORIA churn
-- Conclusão: Uma solução para melhora de resultados da empresa consiste em converter o máximo de clientes de contratos mensais para anuais, focando nesse nível de contrato, com uma revisão de valor de mensalidade dentro da média da massa que analisamos que não costuma virar churn