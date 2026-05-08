-- ============================================================
-- ESTUDO: SQL Window Functions
-- Banco:  AdventureWorksLT2025 (SQL Server)
-- ============================================================
-- OBJETIVO:
--   Demonstrar o uso de Window Functions (OVER/PARTITION BY)
--   para calcular totais acumulados por grupo, sem colapsar
--   as linhas individuais como faria um GROUP BY simples.
--
-- CONCEITOS ABORDADOS:
--   - CTE (Common Table Expression)
--   - SUM()  OVER (PARTITION BY ...) → total do grupo por janela
--   - LAG()  OVER (PARTITION BY ...) → valor da linha anterior
--   - Diferença entre GROUP BY e Window Function
-- ============================================================

-- USE AdventureWorksLT2025;

-- ------------------------------------------------------------
-- CTE: Agrega vendas por cidade, estado e ano
-- ------------------------------------------------------------
;WITH ResumoVendas AS (
    SELECT 
        Addr.City                         AS cidade,
        Addr.StateProvince                AS estado,
        DATEPART(yy, Header.OrderDate)    AS ano,
        SUM(Detail.OrderQty)              AS qtd,
        SUM(Detail.LineTotal)             AS total_vendas
    FROM SalesLT.SalesOrderHeader AS Header
    INNER JOIN SalesLT.SalesOrderDetail AS Detail
        ON Header.SalesOrderID = Detail.SalesOrderID
    INNER JOIN SalesLT.Address AS Addr
        ON Header.ShipToAddressID = Addr.AddressID
    GROUP BY
        Addr.City,
        Addr.StateProvince,
        DATEPART(yy, Header.OrderDate)
)

SELECT 
    cidade,
    estado,
    ano,
    qtd,
    SUM(qtd)  OVER (PARTITION BY estado)                        AS qtd_total_estado,
    LAG(qtd, 1) OVER (PARTITION BY estado ORDER BY qtd DESC)    AS qtd_cidade_anterior,
    RANK()      OVER (PARTITION BY estado ORDER BY qtd DESC)    AS ranking_estado
FROM ResumoVendas
ORDER BY qtd_total_estado DESC, ranking_estado;

-- ------------------------------------------------------------
-- SELECT FINAL: Aplica Window Functions sobre o resultado da CTE
--
-- SUM(qtd) OVER (PARTITION BY estado)
--   → total de unidades vendidas no estado (repete em cada linha)
--
-- LAG(qtd, 1) OVER (PARTITION BY estado ORDER BY qtd DESC)
--   → qtd da cidade anterior dentro do mesmo estado
--   → útil para comparar se a cidade atual vendeu mais ou menos
--      que a anterior no ranking
-- ------------------------------------------------------------