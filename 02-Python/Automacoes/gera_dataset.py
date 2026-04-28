import random
from datetime import datetime, timedelta
from pathlib import Path
import pandas as pd
import names

# Criar pasta datasets
pasta_datasets = Path(__file__).parent / 'datasets'
pasta_datasets.mkdir(parents=True, exist_ok=True)

# Dados base
LOJAS = [
    {"estado": "SP", "cidade": "São Paulo", "vendedores": ["Ana Oliveira", "Bruno Silva", "Carla Santos"]},
    {"estado": "MG", "cidade": "Belo Horizonte", "vendedores": ["Carlos Silva", "Maria Clara", "João Vitor"]},
    {"estado": "RJ", "cidade": "Rio de Janeiro", "vendedores": ["Juliana Almeida", "Pedro Sousa", "Vinicius Sanches"]},
    {"estado": "SP", "cidade": "Assis", "vendedores": ["Maria Vitoria", "Roberto Ferreira", "Mariana Gomes"]},
    {"estado": "PR", "cidade": "Cambará", "vendedores": ["Ana Maria", "Beatriz Dias", "Vitoria Martins"]}
]

PRODUTOS = [
    {"nome": "Notebook", "id": 0, "preco": 3500.00},
    {"nome": "Smartphone", "id": 1, "preco": 2000.00},
    {"nome": "Tablet", "id": 2, "preco": 1500.00},
    {"nome": "Monitor", "id": 3, "preco": 800.00},
    {"nome": "Teclado", "id": 4, "preco": 150.00},
    {"nome": "Mouse", "id": 5, "preco": 100.00},
    {"nome": "Impressora", "id": 6, "preco": 1200.00},
    {"nome": "Cadeira Gamer", "id": 7, "preco": 900.00},
    {"nome": "Mesa para Escritório", "id": 8, "preco": 700.00},
    {"nome": "Headset", "id": 9, "preco": 300.00}
]

FORMA_PAGTO = ["Cartão de Crédito", "Boleto", "Pix", "Transferência Bancária"]
GENERO_CLIENTE = ["Masculino", "Feminino", "Outro"]

compras = []

# Geração de dados
for i in range(2000):
    loja = random.choice(LOJAS)
    vendedor = random.choice(loja["vendedores"])
    produto = random.choice(PRODUTOS)

    hora_compra = datetime.now() - timedelta(
        days=random.randint(1, 365),
        hours=random.randint(0, 23),
        minutes=random.randint(0, 59)
    )

    genero_cliente = random.choice(GENERO_CLIENTE)

    if genero_cliente == "Masculino":
        nome_cliente = names.get_full_name(gender='male')
    elif genero_cliente == "Feminino":
        nome_cliente = names.get_full_name(gender='female')
    else:
        nome_cliente = names.get_full_name()

    forma_pagto = random.choice(FORMA_PAGTO)

    compras.append({
        "data": hora_compra,
        "id_compra": i,
        "estado": loja["estado"],
        "loja": loja["cidade"],
        "vendedor": vendedor,
        "produto": produto["nome"],
        "produto_id": produto["id"],
        "preco": produto["preco"],
        "cliente_nome": nome_cliente,
        "cliente_genero": genero_cliente.replace("Masculino", "M").replace("Feminino", "F").replace("Outro", "O"),
        "forma_pagto": forma_pagto
    })

# DataFrames
df_compras = pd.DataFrame(compras).set_index("data").sort_index()
df_lojas = pd.DataFrame(LOJAS)
df_produtos = pd.DataFrame(PRODUTOS)

# Exibir
print(df_lojas.head())
print(df_produtos.head())
print(df_compras.head())

# Salvar arquivos CSV
df_compras.to_csv(pasta_datasets / "compras.csv")
df_lojas.to_csv(pasta_datasets / "lojas.csv", index=False)
df_produtos.to_csv(pasta_datasets / "produtos.csv", index=False)