-- ================================================
-- ADVENTUREWORKSLT2025 - Análise de Clientes
-- Conceitos: SELECT com alias, GROUP BY, ORDER BY, LEFT JOIN, WHERE IS NULL
-- ================================================
 
USE AdventureWorksLT2025;

-- Dados principais dos clientes

SELECT 
    CustomerID,
    FirstName + ' ' + LastName AS nome_completo,
    CompanyName,
    EmailAddress,
    Phone
FROM SalesLT.Customer;
 
-- Clientes por empresa (quantos contatos por empresa)

SELECT 
    CompanyName,
    COUNT(*) AS total_clientes
FROM SalesLT.Customer
GROUP BY CompanyName
ORDER BY total_clientes DESC;
 
-- Clientes que nunca fizeram pedido

SELECT 
    c.CustomerID, 
    c.FirstName, 
    c.LastName
FROM SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;
 

-- Valor total gasto por cliente 
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS nome_completo,
    c.EmailAddress,
    soh.subTotal
FROM SalesLT.Customer c
INNER JOIN SalesLT.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
ORDER BY soh.subTotal DESC;

