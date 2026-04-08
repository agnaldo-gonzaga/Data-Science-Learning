# Apagar o banco se já existir e recriar do zero
DROP DATABASE IF EXISTS amazon_sales;
CREATE DATABASE amazon_sales;
USE amazon_sales;


-- Apagar a tabela se existir e  criando nova tabela tabela
DROP TABLE IF EXISTS vendas;
CREATE TABLE vendas (
    index_id           INT,
    order_id           VARCHAR(100),
    date               VARCHAR(100),
    status             VARCHAR(100),
    fulfilment         VARCHAR(100),
    sales_channel      VARCHAR(100),
    ship_service_level VARCHAR(100),
    style              VARCHAR(100),
    sku                VARCHAR(100),
    category           VARCHAR(100),
    size               VARCHAR(100),
    asin               VARCHAR(100),
    courier_status     VARCHAR(100),
    qty                INT,
    currency           VARCHAR(100),
    amount             DECIMAL(10,2),
    ship_city          VARCHAR(100),
    ship_state         VARCHAR(100),
    ship_postal_code   DECIMAL(10,2),
    ship_country       VARCHAR(100),
    b2b                VARCHAR(10)
);

# Carregando o CSV amazon com os dados ja tratado
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_limpo.csv'
INTO TABLE vendas
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
 .
SELECT COUNT(*) FROM vendas;