import streamlit as st
import pandas as pd   

caminho_compra = "D:\\Area de trabalho\\Data-Science-Learning\\02-Python\\Automacoes\\datasets\\compras.csv"

df_compras = pd.read_csv(caminho_compra,  sep=',', decimal=".", index_col=0)

colunas = list(df_compras.columns)
colunas_selecionadas = st.sidebar.multiselect("Seleciona as colunas:", colunas, default=colunas)

col1, col2 = st.sidebar.columns(2)
col_filtro = col1.selectbox("Selecione a colunas:",
               [c for c in colunas if c not in ["id_compra, id_cliente, id_produto"]])


valor_filtro = col2.selectbox("Selecione o valor do filtro:", 
               list(df_compras[col_filtro].unique()))

str_filtrar = col1.button("Aplicar Filtro")
str_limpar =  col2.button("Limpar Filtro")


if str_filtrar:
    st.dataframe(df_compras.loc[df_compras[col_filtro] == valor_filtro, colunas_selecionadas    ])
elif str_limpar:    st.dataframe(df_compras[colunas_selecionadas])
else: 
     st.dataframe(df_compras[colunas_selecionadas])