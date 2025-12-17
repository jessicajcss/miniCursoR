## 16-12-2025 ##
## Última atualização: ---

######################################################
# Análise de dados LACIA
######################################################

######################################################
# Parte 0. Carregando as bibliotecas
######################################################

library(tidyverse)   # Manipulação e visualização de dados
library(data.table)  # Leitura rápida de arquivos grandes (fread)

######################################################
# Parte 1. Upload do banco de dados – Estação Terreno
######################################################

# Listar arquivos CSV do diretório da estação terreno
temp <- list.files(
  path = "./data/lacia/dados estação terreno/",
  pattern = "*.CSV"
)

head(temp)

# Definir diretório base
dir <- "./data/lacia/dados estação terreno/"

# Criar caminhos completos dos arquivos
temp.qualified <- paste(dir, temp, sep = "/")

# Leitura de todos os arquivos CSV
myfiles <- lapply(temp.qualified, fread)

class(myfiles)
summary(myfiles)
View(myfiles)

######################################################
# Verificação de consistência dos nomes das colunas
######################################################

my_func <- function(x, y) {
  for (i in names(x)) {
    if (!(i %in% names(y))) {
      print("Warning: Names are not the same")
      break
    } else if (i == tail(names(y), n = 1)) {
      print("Names are identical")
    }
  }
}

# Exemplo de comparação entre dois arquivos
my_func(myfiles[[1]], myfiles[[14]])

######################################################
# Unificação das planilhas da estação terreno
######################################################

dados_estacao <- do.call("rbind", myfiles)

######################################################
# Parte 2. Upload do banco de dados – Dados de Nível
######################################################

# Listar arquivos CSV do diretório de dados de nível
temp <- list.files(
  path = "./data/lacia/dados nível/",
  pattern = "*.csv"
)

head(temp)

# Definir diretório base
dir <- "./data/lacia/dados nível/"

# Criar caminhos completos
temp.qualified <- paste(dir, temp, sep = "/")

######################################################
# Leitura do primeiro arquivo (inspeção inicial)
######################################################

myfiles0 <- fread(
  temp.qualified[1],
  header = TRUE,
  sep = ",",
  dec = ",",
  skip = 10
)

View(myfiles0[1])

######################################################
# Leitura dos demais arquivos
######################################################

myfiles <- lapply(
  temp.qualified[-1],
  fread,
  drop = "Não",
  header = TRUE,
  skip = 10
)

class(myfiles)
summary(myfiles)
View(myfiles)

######################################################
# Verificação de consistência das colunas
######################################################

my_func <- function(x, y) {
  for (i in names(x)) {
    if (!(i %in% names(y))) {
      print("Warning: Names are not the same")
      break
    } else if (i == tail(names(y), n = 1)) {
      print("Names are identical")
    }
  }
}

my_func(myfiles[[1]], myfiles[[6]])

######################################################
# Unificação das planilhas de dados de nível
######################################################

dados_nivel <- do.call("bind_rows", myfiles)

######################################################
# Parte 3. Conversão do separador decimal
######################################################

# OPÇÃO 1 – Converter colunas nomeadas
# Substitua col1, col2 pelos nomes reais das colunas

dados_nivel <- dados_nivel %>%
  mutate(
    across(
      c(col1, col2),
      ~ as.numeric(str_replace(., ",", "."))
    )
  )

# OPÇÃO 2 – Converter colunas por índice
cols_to_convert <- c(2:5)

dados_nivel <- dados_nivel %>%
  mutate(
    across(
      all_of(cols_to_convert),
      ~ as.numeric(gsub(",", ".", .x, fixed = TRUE))
    )
  )

######################################################
# Objetos finais:
# - dados_estacao : dados consolidados da estação terreno
# - dados_nivel   : dados consolidados de nível (numéricos ajustados)
######################################################
