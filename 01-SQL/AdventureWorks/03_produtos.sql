-- ================================================
-- ADVENTUREWORKSLT2025 - Análise de Produtos
-- Conceitos: JOIN, AVG, TOP, LEFT JOIN, WHERE IS NULL
-- ================================================
 
USE AdventureWorksLT2025;
 
-- Produtos agrupados por categoria com preço médio

SELECT 
    pc.Name AS categoria,
    COUNT(p.ProductID) AS total_produtos,
    AVG(p.ListPrice)   AS preco_medio
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY total_produtos DESC;
 
-- Top 10 produtos mais caros

SELECT TOP 10
    Name,
    ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;
 
-- Produtos que nunca foram vendidos

SELECT 
    p.ProductID, 
    p.Name
FROM SalesLT.Product p
LEFT JOIN SalesLT.SalesOrderDetail d ON p.ProductID = d.ProductID
WHERE d.ProductID IS NULL;


-- Produtos que tiveram desconto aplicado nas vendas
SELECT 
    p.Name                         AS produto,
    AVG(d.UnitPriceDiscount) * 100 AS desconto_medio_pct,
    SUM(d.OrderQty)                AS qtd_vendida
FROM SalesLT.SalesOrderDetail d
JOIN SalesLT.Product p ON d.ProductID = p.ProductID
WHERE d.UnitPriceDiscount > 0
GROUP BY p.Name
ORDER BY desconto_medio_pct DESC;
 
-- Margem estimada por produto (ListPrice vs StandardCost)
-- NULLIF evita divisão por zero
SELECT 
    Name,
    ListPrice,
    StandardCost,
    ListPrice - StandardCost AS margem_bruta,
    ROUND((ListPrice - StandardCost) / NULLIF(ListPrice, 0) * 100, 2) AS margem_pct
FROM SalesLT.Product
WHERE ListPrice > 0
ORDER BY margem_pct DESC;