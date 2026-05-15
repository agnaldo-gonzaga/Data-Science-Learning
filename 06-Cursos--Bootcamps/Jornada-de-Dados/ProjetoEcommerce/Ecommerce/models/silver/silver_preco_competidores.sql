-- ============================================
-- CAMADA SILVER: Preços de Concorrentes (Dados Limpos)
-- ============================================
-- Conceito: Segunda camada da arquitetura Medalhão
-- Objetivo: Criar colunas calculadas a partir dos dados brutos

SELECT
    id_produto,
    nome_concorrente,
    preco_concorrente,
    data_coleta,
    DATE(data_coleta::timestamp) AS data_coleta_date
FROM {{ ref('bronze_preco_competidores') }}