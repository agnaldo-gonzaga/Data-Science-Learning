use amazon_sales

-- Visão geral dos dados
SELECT * FROM vendas LIMIT 10;
SELECT COUNT(*) FROM vendas;
SELECT COUNT(DISTINCT category) FROM vendas;

-- Total de vendas por categoria
SELECT category, SUM(amount), COUNT(*) FROM vendas GROUP BY category ORDER BY SUM(amount) DESC;


-- Ticket médio por canal de venda
SELECT sales_channel, AVG(amount) FROM vendas GROUP BY sales_channel;