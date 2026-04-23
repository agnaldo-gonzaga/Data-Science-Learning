-- ================================================
-- ADVENTUREWORKSLT2025 -  Análise de Vendas
-- Conceitos: SUM, AVG, COUNT, YEAR, MONTH, GROUP BY, ORDER BY, JOIN
-- ================================================
 
USE AdventureWorksLT2025;
 
-- Receita total, quantidade de pedidos e ticket médio
SELECT 
    SUM(TotalDue) AS receita_total,
    COUNT(*)      AS total_pedidos,
    AVG(TotalDue) AS ticket_medio
FROM SalesLT.SalesOrderHeader;
 
-- Receita agrupada por mês e ano
SELECT 
    YEAR(OrderDate)  AS ano,
    MONTH(OrderDate) AS mes,
    SUM(TotalDue)    AS receita
FROM SalesLT.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY ano, mes;
 
-- Top 10 clientes que mais gastaram
SELECT TOP 10
    c.FirstName + ' ' + c.LastName AS cliente,
    SUM(o.TotalDue)                AS total_gasto
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY total_gasto DESC;