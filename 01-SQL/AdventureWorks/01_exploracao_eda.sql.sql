-- ================================================
-- ADVENTUREWORKSLT2025
-- Exploração Inicial (EDA)
-- Conceitos: SELECT *, UNION ALL, COUNT
-- ================================================

USE AdventureWorksLT2025;

-- Visualização geral da tabela de clientes
SELECT * FROM SalesLT.Customer; 

-- Total de registros por tabela
SELECT 'Customer'          AS tabela, COUNT(*) AS total FROM SalesLT.Customer
UNION ALL
SELECT 'Product',                     COUNT(*) FROM SalesLT.Product
UNION ALL
SELECT 'SalesOrderHeader',            COUNT(*) FROM SalesLT.SalesOrderHeader
UNION ALL
SELECT 'SalesOrderDetail',            COUNT(*) FROM SalesLT.SalesOrderDetail
UNION ALL
SELECT 'ProductCategory',             COUNT(*) FROM SalesLT.ProductCategory
UNION ALL
SELECT 'ProductModel',                COUNT(*) FROM SalesLT.ProductModel;