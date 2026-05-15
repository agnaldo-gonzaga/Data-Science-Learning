-- ============================================
-- CAMADA SILVER: Produtos (Dados Limpos)
-- ============================================
-- Conceito: Segunda camada da arquitetura Medalhão
-- Objetivo: Criar colunas calculadas a partir dos dados brutos

SELECT
    id_produto,
    nome_produto,
    categoria,
    marca,
    preco_atual,
    data_criacao,
    -- Colunas calculadas
    CASE
        WHEN preco_atual > 1000 THEN 'PREMIUM'
        WHEN preco_atual > 500 THEN 'MEDIO'
        ELSE 'BASICO'
    END AS faixa_preco
FROM {{ ref('bronze_produtos') }}