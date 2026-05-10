import random
import numpy as np
import pandas as pd

# =============================================================
# Amostragem por Reservatório (Reservoir Sampling)
# -------------------------------------------------------------
# Técnica estatística usada para selecionar k amostras aleatórias
# de um stream de dados de tamanho desconhecido ou muito grande,
# garantindo que cada elemento tenha igual probabilidade de seleção.
# Referência: Algoritmo de Vitter (1985)
# =============================================================

# -------------------------------------------------------------
# Dataset de exemplo com 10 registros
# -------------------------------------------------------------
data = {'codigo': np.arange(1, 11).tolist()}
dataset = pd.DataFrame(data)



def amostragem_reservatorio(dataset, amostras):
    
    # Validação: número de amostras não pode exceder o dataset
    
    if amostras > len(dataset):
        raise ValueError(f"Amostras ({amostras}) não pode ser maior que o dataset ({len(dataset)})")
    
     # Cria um stream com os índices do dataset
    stream = []
    for i in range(len(dataset)):
        stream.append(i)

  # Inicializa o reservatório com os primeiros k índices
  
    reservatorio = [0] * amostras

    for i in range(amostras):
        reservatorio[i] = stream[i]

    # Percorre o restante do stream substituindo elementos
    # aleatoriamente no reservatório (garante distribuição uniforme)
    
    i = amostras  
    tamanho = len(dataset)

    while i < tamanho:
        j = random.randrange(i + 1) # índice aleatório entre 0 e i
        if j < amostras:
            reservatorio[j] = stream[i] # substitui elemento no reservatório
        i += 1

# Retorna as linhas do dataset correspondentes aos índices selecionados
    return dataset.iloc[reservatorio]


# -------------------------------------------------------------
# Execução: seleciona 3 amostras aleatórias do dataset
# -------------------------------------------------------------

df_amostragem_reservatorio = amostragem_reservatorio(dataset, 3)
print(df_amostragem_reservatorio)
print('Shape:', df_amostragem_reservatorio.shape)