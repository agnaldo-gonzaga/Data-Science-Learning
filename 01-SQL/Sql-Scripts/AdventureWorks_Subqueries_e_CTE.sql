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
