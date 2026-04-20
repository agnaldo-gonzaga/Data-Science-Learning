-- ================================================
-- ADVENTUREWORKSLT2025 - ESTUDO COMPLETO
-- Data Science Journey | SQL Server
-- ================================================

USE AdventureWorksLT2025;

-- ================================================
-- 1. EXPLORAÇÃO INICIAL (EDA)
-- ================================================


SELECT * FROM SalesLT.Customer; 

-- Total de registros por tabela

SELECT 'Customer'     AS tabela, COUNT(*) AS total FROM SalesLT.Customer
UNION ALL
SELECT 'Product',              COUNT(*) FROM SalesLT.Product
UNION ALL
SELECT 'SalesOrderHeader',     COUNT(*) FROM SalesLT.SalesOrderHeader
UNION ALL
SELECT 'SalesOrderDetail',     COUNT(*) FROM SalesLT.SalesOrderDetail
UNION ALL
SELECT 'ProductCategory',      COUNT(*) FROM SalesLT.ProductCategory
UNION ALL
SELECT 'ProductModel',         COUNT(*) FROM SalesLT.ProductModel;

-- ================================================
-- 2. CLIENTES
-- ================================================


SELECT 
    CustomerID,
    FirstName + ' ' + LastName AS nome_completo,
    CompanyName,
    EmailAddress,
    Phone
FROM SalesLT.Customer;


-- Clientes por empresa

SELECT 
    CompanyName,
    COUNT(*) AS total_clientes
FROM SalesLT.Customer
GROUP BY CompanyName
ORDER BY total_clientes DESC;


-- Clientes sem pedidos

SELECT c.CustomerID, c.FirstName, c.LastName
FROM SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


-- ================================================
-- 3. PRODUTOS
-- ================================================

-- Produtos por categoria

SELECT 
    pc.Name AS categoria,
    COUNT(p.ProductID) AS total_produtos,
    AVG(p.ListPrice) AS preco_medio
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY total_produtos DESC;


-- Produtos mais caros

SELECT TOP 10
    Name,
    ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;


-- Produtos sem venda

SELECT p.ProductID, p.Name
FROM SalesLT.Product p
LEFT JOIN SalesLT.SalesOrderDetail d ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;



-- ================================================
-- 4. VENDAS
-- ================================================

-- Receita total

SELECT 
    SUM(TotalDue) AS receita_total,
    COUNT(*) AS total_pedidos,
    AVG(TotalDue) AS ticket_medio
FROM SalesLT.SalesOrderHeader;


-- Receita por mês

SELECT 
    YEAR(OrderDate)  AS ano,
    MONTH(OrderDate) AS mes,
    SUM(TotalDue)    AS receita
FROM SalesLT.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY ano, mes;

-- Top 10 clientes por receita

SELECT TOP 10
    c.FirstName + ' ' + c.LastName AS cliente,
    SUM(o.TotalDue) AS total_gasto
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY total_gasto DESC;