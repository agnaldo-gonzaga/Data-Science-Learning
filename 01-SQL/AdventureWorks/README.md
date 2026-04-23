# AdventureWorksLT2025 — SQL Study Journey 🗺️

Estudo progressivo do banco AdventureWorksLT2025 como parte da minha jornada em dados .

---

## 📁 Arquivos

| Dia | Arquivo | Conceitos Praticados |
|-----|---------|----------------------|
| 01 | `01_exploracao_eda.sql` | SELECT *, UNION ALL, COUNT |
| 02 | `02_clientes.sql` | Alias, GROUP BY, ORDER BY, LEFT JOIN, IS NULL |
| 03 | `03_produtos.sql` | INNER JOIN, AVG, TOP, LEFT JOIN |
| 04 | `04_vendas.sql` | SUM, AVG, COUNT, YEAR, MONTH, JOIN |
| 05 | `05_analise_produtos.sql` | Filtros numéricos, NULLIF, ROUND |
| 06 | `06_segmentacao_rfm.sql` | DATEDIFF, GETDATE, MAX, CASE WHEN |
| 07 | `07_analise_pedidos.sql` | MIN, MAX, AVG com datas, CASE WHEN |
| 08 | `08_window_functions.sql` | RANK, DENSE_RANK, ROW_NUMBER, OVER, PARTITION BY, Running Total |

---

## 🧠 Aprendizados principais

- **LEFT JOIN + IS NULL** → encontrar registros sem correspondência (clientes sem pedido, produtos sem venda)
- **NULLIF** → evitar divisão por zero em cálculos de margem
- **DATEDIFF + GETDATE** → calcular recência de clientes (base do RFM)
- **CASE WHEN** → criar colunas calculadas e segmentos de negócio
- **WINDOW FUNCTIONS** → ranking e acumulados sem perder granularidade das linhas

---

## 🗄️ Diagrama das tabelas usadas

```
Customer ──────────── SalesOrderHeader ──────────── SalesOrderDetail
                                                          │
Product ──────────────────────────────────────────────────┘
   │
ProductCategory
   │
ProductModel
```

---


