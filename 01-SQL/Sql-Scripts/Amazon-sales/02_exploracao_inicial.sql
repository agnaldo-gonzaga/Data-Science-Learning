use amazon_sales

-- Visão geral dos dados
SELECT * FROM vendas LIMIT 10;
SELECT COUNT(*) FROM vendas;
SELECT COUNT(DISTINCT category) FROM vendas;

-- Total de vendas por categoria
SELECT category, SUM(amount), COUNT(*) FROM vendas GROUP BY category ORDER BY SUM(amount) DESC;


-- Ticket médio por canal de venda
SELECT sales_channel, AVG(amount) FROM vendas GROUP BY sales_channel;

-- Vendas apenas com status "Shipped"
SELECT * FROM vendas WHERE status = 'Shipped';

-- Vendas acima de R$500
SELECT * FROM vendas WHERE amount > 500;

-- Vendas entre datas
SELECT * FROM vendas WHERE date BETWEEN '2022-04-01' AND '2022-04-30';


-- Pedidos cancelados por estado
SELECT ship_state, COUNT(*) AS cancelados
FROM vendas
WHERE status = 'Cancelled'
GROUP BY ship_state
ORDER BY cancelados DESC;


-- CASE WHEN --

-- Classificar pedidos por valor
SELECT order_id, amount,
  CASE
    WHEN amount < 300 THEN 'Baixo'
    WHEN amount BETWEEN 300 AND 700 THEN 'Médio'
    ELSE 'Alto'
  END AS faixa_valor
FROM vendas;


-- Taxa de cancelamento por categoria
SELECT category, 
  COUNT(*) AS total,
  SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelados,
  ROUND(SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_cancelamento
FROM vendas
GROUP BY category;