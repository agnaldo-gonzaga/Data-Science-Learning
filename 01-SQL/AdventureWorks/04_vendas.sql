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

-- Top 10 produtos mais vendidos por valor

SELECT TOP 10
    p.Name AS produto,
    SUM(d.LineTotal) AS receita_produto
FROM SalesLT.Product p
JOIN SalesLT.SalesOrderDetail d
    ON p.ProductID = d.ProductID
GROUP BY p.Name
ORDER BY receita_produto DESC;


-- Clientes com mais pedidos

SELECT TOP 10
    c.FirstName + ' ' + c.LastName AS cliente,
    COUNT(o.SalesOrderID) AS qtd_pedidos
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY qtd_pedidos DESC;

-- Ticket médio por cliente

SELECT TOP 10
    c.FirstName + ' ' + c.LastName AS cliente,
    AVG(o.TotalDue) AS ticket_medio
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader o
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY ticket_medio DESC;A

-- Receita por categoria de produto

SELECT
    pc.Name AS categoria,
    SUM(d.LineTotal) AS receita
FROM SalesLT.ProductCategory pc
JOIN SalesLT.Product p
    ON pc.ProductCategoryID = p.ProductCategoryID
JOIN SalesLT.SalesOrderDetail d
    ON p.ProductID = d.ProductID
GROUP BY pc.Name
ORDER BY receita DESC;

-- Produtos nunca vendidos

SELECT
    p.ProductID,
    p.Name
FROM SalesLT.Product p
LEFT JOIN SalesLT.SalesOrderDetail d
    ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;
