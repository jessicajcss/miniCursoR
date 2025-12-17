## 16-12-2025 ##
## Última atualização: ---

######################################################
# Análise de dados LACIA
######################################################

######################################################
# Parte 0. Carregando as bibliotecas
######################################################

library(tidyverse)   # Manipulação e visualização de dados

install.packages("data.table")
library(data.table)  # Leitura rápida de arquivos grandes (fread)


######################################################
# Parte 1. Upload do banco de dados – Estação Terreno ----
######################################################

# Listar arquivos CSV do diretório da estação terreno
temp <- list.files(
  path = "./data/lacia/dados estação terreno/",
  pattern = "*.CSV"
)

head(temp)


# Definir diretório base
dir <- "./data/lacia/dados estação terreno"

# Criar caminhos completos dos arquivos
temp.qualified <- paste(dir, temp, sep = "/")

# Leitura de todos os arquivos CSV
myfiles <- lapply(temp.qualified,
                  read.delim,
                  sep = ",")

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
bind_rows()

dados_estacao <- do.call("rbind", myfiles)




######################################################
# Parte 2. Upload do banco de dados – Dados de Nível ----
######################################################

# Listar arquivos CSV do diretório de dados de nível
temp <- list.files(
  path = "./data/lacia/dados nível/",
  pattern = "*.csv"
)

head(temp)

# Definir diretório base
dir <- "./data/lacia/dados nível"

# Criar caminhos completos
temp.qualified <- paste(dir, temp, sep = "/")

######################################################
# Leitura do primeiro arquivo (inspeção inicial)
######################################################

myfiles <- lapply(temp.qualified,
                  read.delim,
                  header = TRUE,
                  sep = ",",
                  dec = ",",
                  skip = 11)


myfiles0 <- fread(  #  Para resolver problemas do banco de dados de entrada, que contém "'" no início da primeira linha.
  temp.qualified[1],
  drop = "Não",
  sep = ",",
  skip = 10
)

#View(myfiles0[1])

######################################################
# Leitura dos demais arquivos
######################################################

myfiles <- lapply(
  temp.qualified[-1],
  fread,
  drop = "Não",
  header = TRUE,
  skip = 11
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

my_func(myfiles[[1]], myfiles[[7]])

######################################################
# Unificação das planilhas de dados de nível
######################################################

dados_nivel <- do.call("bind_rows", myfiles) # aqui, usou-se aplenas o 'myfiles' pois banco de dados myfiles[[1]] repete-se no myfiles[[2]]




######################################################
# Parte 3. Data wrangling: Conversão do separador decimal
######################################################

# OPÇÃO 1 – Converter colunas nomeadas
# Substitua col1, col2 pelos nomes reais das colunas

dados_nivel <- dados_nivel %>% # Nao rodar!!! apenas um exemplo!
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
      all_of(c(2:5)),
      ~ as.numeric(gsub(",", ".", .x, fixed = TRUE))
    )
  )


dados_nivel <- dados_nivel %>%
  mutate(temp = `Temperatura (°C)`)





######################################################
# Parte 3. Data wrangling: Conversão colunas numéricas
######################################################


dados_estacao <- dados_estacao %>%
  mutate(across(c(2:27), ~ as.numeric(as.character(.))),
         Time = ymd_hms(Time, tz = "America/Sao_Paulo"))



dados_nivel <- dados_nivel %>%
  mutate(Data = dmy_hms(Data, tz = "America/Sao_Paulo"))

dados_nivel <- dados_nivel %>%
  mutate(Data = dmy_hms(Data, tz = "America/Sao_Paulo"))

dados_nivel$Data <- as.POSIXct(dados_nivel$Data)


######################################################
# Parte 3. Data wrangling: Eliminar linhas duplicadas
######################################################

dados_estacao <- dados_estacao %>%
  unique()


dados_nivel <- dados_nivel %>%
  distinct()






######################################################
# Parte 4. Data wrangling: Checando os dados
######################################################
# Renomeando colunas

# Opção 1:
dados_estacao_reduzido <- dados_estacao %>%
  select(Time, Outdoor.Temperature.C., Outdoor.Humidity..., 
         Wind.m.s., Wind.Direction.deg., Rain.Event.mm., Solar.Rad.w.m2.)


colnames(dados_estacao_reduzido) <- c('date', 'temp', 'umid', 'ws', 'wd', 'prec', 'rad')



# Opção 2:

dados_estacao <- dados_estacao %>%
  rename(date = Time,
         ...)


# View structure and summary
glimpse(dados_estacao_reduzido)
summary(dados_estacao_reduzido)



# Limpando pelos dados de umidade

dados_estacao_reduzido <- dados_estacao_reduzido  %>%
  filter(!if_any(everything(), ~ . == 6553.0)) %>%
  subset(umid <= 100)

# --------------------------------------------------------------------------------------------------------
#                                   OUTLIER DETECTION AND REMOVAL
# --------------------------------------------------------------------------------------------------------

# Função para detectar outliers usando percentis
detect_outlier <- function(x) {
  
  # Calcular primeiro e terceiro percentil
  Percentile1 <- stats::quantile(x, probs = 0.05, na.rm = TRUE)
  Percentile3 <- stats::quantile(x, probs = 0.95, na.rm = TRUE)
  
  # Calcular intervalo interpercentil
  IPR <- Percentile3 - Percentile1
  
  # Retornar verdadeiro para valores que são outliers
  x > Percentile3 + (IPR * 1.5) | x < Percentile1 - (IPR * 1.5)
}

# Função para remover outliers de colunas específicas
remove_outlier <- function(dataframe, columns = names(dataframe)) {
  dataframe <- dataframe |> dplyr::ungroup() # Remover agrupamento antes da filtragem
  
  for (col in columns) {
    dataframe <- dataframe[!detect_outlier(dataframe[[col]]), ]
  }
  
  return(dataframe) # Retornar o dataframe sem imprimir
}




df <- dados_estacao_reduzido  %>%
  remove_outlier(c('temp', 'umid', 'ws', 'wd', 'prec', 'rad'))
  
summary(df)

######################################################
# Objetos finais:
# - dados_estacao : dados consolidados da estação terreno
# - dados_nivel   : dados consolidados de nível (numéricos ajustados)
######################################################


















######################################################
# Parte 4. Visualização
######################################################

g1 <- dados_estacao %>%
  ggplot(aes(x = Time, y = Outdoor.Temperature.C.)) +
  geom_line() +
  scale_x_date(date_breaks = "month", date_labels = "%b/'%y") +
  scale_y_continuous(labels = scales::label_comma()) +
  scale_color_manual(values = c(day = "#FFA200", night = "#757BC7")) +
  labs(x = NULL, y = "Temperatura média (ºC)")



