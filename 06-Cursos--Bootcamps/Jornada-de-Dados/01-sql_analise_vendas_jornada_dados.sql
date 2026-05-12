-- ================================================================
-- PROJETO: Análise de Vendas com SQL
-- BOOTCAMP: Jornada de Dados

-- ================================================================
-- DESCRIÇÃO:
--   Análise completa de um sistema de vendas com 3 tabelas:
--   vendas, produtos e clientes. Cobre desde exploração inicial
--   até window functions avançadas, espelhando a arquitetura
--   Medallion (Bronze → Silver → Gold) usada com dbt.
--
-- TÓPICOS COBERTOS:
--   1. Exploração de dados (SELECT, ORDER BY, LIMIT)
--   2. Filtros (WHERE, BETWEEN, IN, AND/OR)
--   3. Campos calculados e agregações (SUM, AVG, COUNT, MIN, MAX)
--   4. JOINs (INNER JOIN com 2 e 3 tabelas)
--   5. Agrupamentos (GROUP BY com múltiplas dimensões)
--   6. Lógica condicional (CASE WHEN)
--   7. Window Functions (LAG, ROW_NUMBER, PARTITION BY, SUM OVER)
-- ================================================================


-- ================================================================
-- SEÇÃO 1: EXPLORAÇÃO INICIAL DAS TABELAS
-- ================================================================
-- Antes de qualquer análise, entendemos o schema e o conteúdo.
-- Cada tabela tem um papel bem definido no modelo relacional.
-- ================================================================

-- Tabela VENDAS: cada linha é uma transação
-- Colunas: id_venda, data_venda, id_cliente, id_produto,
--          canal_venda, quantidade, preco_unitario
SELECT *
FROM vendas
LIMIT 10;

-- Tabela PRODUTOS: catálogo de itens disponíveis
-- Colunas: id_produto, nome_produto, categoria, marca,
--          preco_atual, data_criacao
SELECT *
FROM produtos
LIMIT 10;

-- Tabela CLIENTES: base de clientes cadastrados
-- Colunas: id_cliente, nome_cliente, estado, pais, data_cadastro
SELECT *
FROM clientes
LIMIT 10;


-- ================================================================
-- SEÇÃO 2: ORDENAÇÃO E FILTRAGEM
-- ================================================================
-- Respondendo perguntas simples de negócio com ORDER BY e WHERE.
-- ================================================================

-- Produtos mais caros do catálogo
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual
FROM produtos
ORDER BY preco_atual DESC
LIMIT 10;

-- Produtos mais baratos do catálogo
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual
FROM produtos
ORDER BY preco_atual ASC
LIMIT 10;

-- Top 10 vendas por valor unitário
SELECT
    id_venda,
    data_venda,
    canal_venda,
    quantidade,
    preco_unitario
FROM vendas
ORDER BY preco_unitario DESC
LIMIT 10;

-- Clientes mais recentemente cadastrados
SELECT
    nome_cliente,
    estado,
    data_cadastro
FROM clientes
ORDER BY data_cadastro DESC
LIMIT 10;

-- Vendas do canal e-commerce (filtro exato com =)
SELECT
    id_venda,
    data_venda,
    canal_venda,
    quantidade,
    preco_unitario
FROM vendas
WHERE canal_venda = 'ecommerce'
LIMIT 20;

-- Vendas da loja física
SELECT
    id_venda,
    data_venda,
    canal_venda,
    quantidade,
    preco_unitario
FROM vendas
WHERE canal_venda = 'loja_fisica'
LIMIT 20;

-- Produtos com preço acima de R$ 500
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual
FROM produtos
WHERE preco_atual > 500
ORDER BY preco_atual DESC;

-- Produtos na faixa de R$ 100 a R$ 500 (operador BETWEEN)
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual
FROM produtos
WHERE preco_atual BETWEEN 100 AND 500
ORDER BY preco_atual DESC;

-- Produtos de categorias específicas (operador IN)
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual
FROM produtos
WHERE categoria IN ('Eletrônicos', 'Tênis')
ORDER BY categoria, preco_atual DESC;

-- Filtros combinados: e-commerce + quantidade > 1 + preço > 100
SELECT
    id_venda,
    canal_venda,
    quantidade,
    preco_unitario
FROM vendas
WHERE canal_venda = 'ecommerce'
  AND quantidade > 1
  AND preco_unitario > 100
ORDER BY preco_unitario DESC
LIMIT 20;


-- ================================================================
-- SEÇÃO 3: CAMPOS CALCULADOS E AGREGAÇÕES
-- ================================================================
-- Criando novas colunas com aritmética e resumindo dados com
-- funções de agregação — base dos modelos Gold no dbt.
-- ================================================================

-- Receita por venda: quantidade × preço_unitário
-- (equivalente ao campo calculado do silver_vendas no dbt)
SELECT
    id_venda,
    quantidade,
    preco_unitario,
    quantidade * preco_unitario AS receita_total
FROM vendas
ORDER BY receita_total DESC
LIMIT 20;

-- Contagem de registros por tabela
SELECT COUNT(*) AS total_vendas    FROM vendas;
SELECT COUNT(*) AS total_produtos  FROM produtos;
SELECT COUNT(*) AS total_clientes  FROM clientes;

-- Receita total de todas as vendas
SELECT
    SUM(quantidade * preco_unitario) AS receita_total
FROM vendas;

-- Estatísticas de preço dos produtos
SELECT
    AVG(preco_atual) AS preco_medio,
    MIN(preco_atual) AS preco_minimo,
    MAX(preco_atual) AS preco_maximo
FROM produtos;

-- Diversidade da base: clientes únicos, produtos e canais
-- COUNT(DISTINCT ...) conta apenas valores não repetidos
SELECT
    COUNT(DISTINCT id_cliente) AS clientes_unicos,
    COUNT(DISTINCT id_produto) AS produtos_vendidos,
    COUNT(DISTINCT canal_venda) AS canais_venda
FROM vendas;

-- Painel completo de KPIs — estilo dashboard executivo (Gold)
SELECT
    COUNT(*)                              AS total_vendas,
    COUNT(DISTINCT id_cliente)            AS clientes_unicos,
    COUNT(DISTINCT id_produto)            AS produtos_vendidos,
    SUM(quantidade)                       AS quantidade_total,
    SUM(quantidade * preco_unitario)      AS receita_total,
    AVG(quantidade * preco_unitario)      AS ticket_medio,
    MIN(quantidade * preco_unitario)      AS menor_venda,
    MAX(quantidade * preco_unitario)      AS maior_venda
FROM vendas;


-- ================================================================
-- SEÇÃO 4: JOINs — COMBINANDO TABELAS
-- ================================================================
-- INNER JOIN conecta tabelas por chave estrangeira.
-- Aqui construímos a visão enriquecida que alimenta o dbt silver.
-- ================================================================

-- JOIN vendas + produtos: enriquece cada venda com dados do produto
SELECT
    v.id_venda,
    v.data_venda,
    v.canal_venda,
    v.quantidade,
    v.preco_unitario,
    p.nome_produto,
    p.categoria,
    p.marca
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
ORDER BY v.data_venda DESC
LIMIT 20;

-- JOIN vendas + clientes: enriquece cada venda com dados do cliente
SELECT
    v.id_venda,
    v.data_venda,
    v.canal_venda,
    v.quantidade,
    v.preco_unitario,
    c.nome_cliente,
    c.estado
FROM vendas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
ORDER BY v.data_venda DESC
LIMIT 20;

-- Triple JOIN: vendas + produtos + clientes
-- Base do silver_vendas_enriquecidas no dbt
SELECT
    v.id_venda,
    v.data_venda,
    v.canal_venda,
    v.quantidade,
    v.preco_unitario,
    v.quantidade * v.preco_unitario  AS receita_total,
    p.nome_produto,
    p.categoria,
    p.marca,
    c.nome_cliente,
    c.estado
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
ORDER BY receita_total DESC
LIMIT 20;


-- ================================================================
-- SEÇÃO 5: GROUP BY — AGREGAÇÕES POR DIMENSÃO
-- ================================================================
-- Respondendo perguntas de negócio sobre performance por grupo.
-- Padrão central dos modelos Gold no dbt.
-- ================================================================

-- Receita total por categoria de produto
-- (equivalente ao gold_kpi_receita_por_categoria)
SELECT
    p.categoria,
    SUM(v.quantidade * v.preco_unitario) AS receita_total,
    COUNT(*)                             AS total_vendas,
    AVG(v.quantidade * v.preco_unitario) AS ticket_medio
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY receita_total DESC;

-- Receita e clientes por estado
SELECT
    c.estado,
    SUM(v.quantidade * v.preco_unitario)  AS receita_total,
    COUNT(*)                              AS total_vendas,
    COUNT(DISTINCT v.id_cliente)          AS total_clientes
FROM vendas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
GROUP BY c.estado
ORDER BY receita_total DESC;

-- Análise cruzada: categoria × canal de venda (2 dimensões)
SELECT
    p.categoria,
    v.canal_venda,
    SUM(v.quantidade * v.preco_unitario) AS receita_total,
    COUNT(*)                             AS total_vendas
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
GROUP BY p.categoria, v.canal_venda
ORDER BY p.categoria, receita_total DESC;


-- ================================================================
-- SEÇÃO 6: CASE WHEN — LÓGICA CONDICIONAL
-- ================================================================
-- Criando categorias e flags de qualidade de dados —
-- lógica diretamente usada na camada Silver do dbt.
-- ================================================================

-- Classificação de produtos por faixa de preço
-- (equivalente ao campo faixa_preco do silver_produtos)
SELECT
    nome_produto,
    categoria,
    marca,
    preco_atual,
    CASE
        WHEN preco_atual > 1000 THEN 'PREMIUM'
        WHEN preco_atual > 500  THEN 'MEDIO'
        ELSE                         'BASICO'
    END AS faixa_preco
FROM produtos
ORDER BY preco_atual DESC;

-- Contagem e preço médio por faixa de preço
SELECT
    CASE
        WHEN preco_atual > 1000 THEN 'PREMIUM'
        WHEN preco_atual > 500  THEN 'MEDIO'
        ELSE                         'BASICO'
    END AS faixa_preco,
    COUNT(*)          AS total_produtos,
    AVG(preco_atual)  AS preco_medio
FROM produtos
GROUP BY faixa_preco
ORDER BY preco_medio DESC;

-- Classificação de vendas por tamanho de receita
SELECT
    id_venda,
    quantidade,
    preco_unitario,
    quantidade * preco_unitario AS receita_total,
    CASE
        WHEN quantidade * preco_unitario > 5000 THEN 'GRANDE'
        WHEN quantidade * preco_unitario > 1000 THEN 'MEDIA'
        ELSE                                         'PEQUENA'
    END AS tamanho_venda
FROM vendas
ORDER BY receita_total DESC
LIMIT 30;

-- Flags de validação de dados (qualidade — camada Silver)
-- Identifica registros com quantidade ou preço inválidos (≤ 0)
SELECT
    id_venda,
    quantidade,
    preco_unitario,
    CASE WHEN quantidade    <= 0 THEN TRUE ELSE FALSE END AS flag_quantidade_invalida,
    CASE WHEN preco_unitario <= 0 THEN TRUE ELSE FALSE END AS flag_preco_invalido
FROM vendas
LIMIT 20;


-- ================================================================
-- SEÇÃO 7: WINDOW FUNCTIONS
-- ================================================================
-- Funções analíticas que calculam sobre um conjunto de linhas
-- sem colapsá-las. Base de KPIs avançados nos modelos Gold.
-- ================================================================

-- LAG(): receita mensal com o mês anterior lado a lado
-- A primeira linha terá receita_mes_anterior = NULL (esperado)
SELECT
    EXTRACT(YEAR  FROM data_venda::timestamp) AS ano,
    EXTRACT(MONTH FROM data_venda::timestamp) AS mes,
    SUM(quantidade * preco_unitario)          AS receita_total,
    LAG(SUM(quantidade * preco_unitario), 1) OVER (
        ORDER BY
            EXTRACT(YEAR  FROM data_venda::timestamp),
            EXTRACT(MONTH FROM data_venda::timestamp)
    ) AS receita_mes_anterior
FROM vendas
GROUP BY
    EXTRACT(YEAR  FROM data_venda::timestamp),
    EXTRACT(MONTH FROM data_venda::timestamp)
ORDER BY ano, mes;

-- LAG() + variação MoM (Month-over-Month)
-- KPI clássico de crescimento para dashboards executivos
SELECT
    EXTRACT(YEAR  FROM data_venda::timestamp) AS ano,
    EXTRACT(MONTH FROM data_venda::timestamp) AS mes,
    SUM(quantidade * preco_unitario)          AS receita_total,

    LAG(SUM(quantidade * preco_unitario), 1) OVER (
        ORDER BY
            EXTRACT(YEAR  FROM data_venda::timestamp),
            EXTRACT(MONTH FROM data_venda::timestamp)
    ) AS receita_mes_anterior,

    -- Variação absoluta em R$
    SUM(quantidade * preco_unitario)
    - LAG(SUM(quantidade * preco_unitario), 1) OVER (
        ORDER BY
            EXTRACT(YEAR  FROM data_venda::timestamp),
            EXTRACT(MONTH FROM data_venda::timestamp)
    ) AS variacao_absoluta,

    -- Variação percentual %
    ROUND(
        (SUM(quantidade * preco_unitario)
         - LAG(SUM(quantidade * preco_unitario), 1) OVER (
             ORDER BY
                 EXTRACT(YEAR  FROM data_venda::timestamp),
                 EXTRACT(MONTH FROM data_venda::timestamp)
         )) * 100.0
        / LAG(SUM(quantidade * preco_unitario), 1) OVER (
            ORDER BY
                EXTRACT(YEAR  FROM data_venda::timestamp),
                EXTRACT(MONTH FROM data_venda::timestamp)
        ),
        2
    ) AS variacao_percentual

FROM vendas
GROUP BY
    EXTRACT(YEAR  FROM data_venda::timestamp),
    EXTRACT(MONTH FROM data_venda::timestamp)
ORDER BY ano, mes;

-- ROW_NUMBER(): ranking global de produtos por receita
-- (equivalente ao gold_kpi_produtos_top_receita)
SELECT
    p.nome_produto,
    p.categoria,
    p.marca,
    SUM(v.quantidade * v.preco_unitario)                             AS receita_total,
    ROW_NUMBER() OVER (ORDER BY SUM(v.quantidade * v.preco_unitario) DESC) AS ranking_receita
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
GROUP BY p.nome_produto, p.categoria, p.marca
ORDER BY ranking_receita
LIMIT 10;

-- ROW_NUMBER() + PARTITION BY: ranking por categoria
-- PARTITION BY reinicia o contador dentro de cada grupo
-- (campo ranking_receita_categoria do gold_kpi_produtos_top_receita)
SELECT
    p.nome_produto,
    p.categoria,
    SUM(v.quantidade * v.preco_unitario) AS receita_total,
    ROW_NUMBER() OVER (
        PARTITION BY p.categoria
        ORDER BY SUM(v.quantidade * v.preco_unitario) DESC
    ) AS ranking_na_categoria
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
GROUP BY p.nome_produto, p.categoria
ORDER BY p.categoria, ranking_na_categoria;

-- SUM() OVER (): percentual de receita por canal de venda
-- SUM(...) OVER () sem PARTITION calcula o total geral como denominador
-- (equivalente ao gold_kpi_receita_por_canal)
SELECT
    canal_venda,
    SUM(quantidade * preco_unitario)      AS receita_total,
    COUNT(*)                              AS total_vendas,
    AVG(quantidade * preco_unitario)      AS ticket_medio,
    ROUND(
        SUM(quantidade * preco_unitario) * 100.0
        / SUM(SUM(quantidade * preco_unitario)) OVER (),
        2
    ) AS percentual_receita
FROM vendas
GROUP BY canal_venda
ORDER BY receita_total DESC;

-- SUM() OVER (): percentual de receita por categoria
SELECT
    p.categoria,
    SUM(v.quantidade * v.preco_unitario) AS receita_total,
    COUNT(*)                             AS total_vendas,
    ROUND(
        SUM(v.quantidade * v.preco_unitario) * 100.0
        / SUM(SUM(v.quantidade * v.preco_unitario)) OVER (),
        2
    ) AS percentual_receita
FROM vendas v
INNER JOIN produtos p
    ON v.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY receita_total DESC;


-- ================================================================
-- FIM DO ARQUIVO
-- Bootcamp: Jornada de Dados | Módulo SQL
-- ================================================================