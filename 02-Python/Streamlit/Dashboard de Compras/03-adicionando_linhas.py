from datetime import datetime
from pathlib import Path
import streamlit as st
import pandas as pd

caminho_datasets = Path(__file__).parent.parent.parent / "Automacoes" / "datasets"

df_compras = pd.read_csv(caminho_datasets / "compras.csv", sep=',', decimal=".", index_col=0)
df_lojas = pd.read_csv(caminho_datasets / "lojas.csv", sep=',', decimal=".", index_col=0)
df_produtos = pd.read_csv(caminho_datasets / "produtos.csv", sep=',', decimal=".", index_col=0)

df_lojas["cidade/estado"] = df_lojas["cidade"] + " / " + df_lojas["estado"]

print(df_lojas.columns)