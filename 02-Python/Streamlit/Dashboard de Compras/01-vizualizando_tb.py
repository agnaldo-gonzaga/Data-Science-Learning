import streamlit as st
import pandas as pd

caminho_compra = '../Automacoes/datasets/compras.csv'

df_compras = pd.read_csv(caminho_compra,  sep=',', decimal=".")

st.dataframe(df_compras)


