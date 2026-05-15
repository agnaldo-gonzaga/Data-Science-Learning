-- ============================================
-- CAMADA SILVER: Clientes (Dados Limpos)
-- ============================================
-- Conceito: Segunda camada da arquitetura Medalhão
-- Objetivo: Padronizar dados de clientes

SELECT
    id_cliente,
    nome_cliente,
    estado,
    pais,
    data_cadastro
FROM {{ ref('bronze_clientes') }}