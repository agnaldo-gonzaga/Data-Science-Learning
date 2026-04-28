-- ================================================
-- ADVENTUREWORKSLT2025 - Exploração do Banco de Dados
--  OBJETIVO: Consultas para explorar a estrutura do banco
-- ================================================


USE AdventureWorksLT2025;


-- Ver todas as tabelas do banco
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME


-- Ver colunas de uma tabela específica
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'SalesLT'
  AND TABLE_NAME = 'Customer'
ORDER BY ORDINAL_POSITION