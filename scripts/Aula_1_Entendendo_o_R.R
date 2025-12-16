# https://posit.cloud/learn/recipes # comandos básicos


################################
# Gerenciamento de arquivos ----
################################


####-- Caminho --####

# Qual o diretório em que você está trabalhando?

getwd() 

a <- 1

# Definir um caminho:
path <- "./data/exer" # '<-' ou '=' podem ser usados, mas '<-' funciona exclusivamente para atribuição de objetos (variáveis)

path <- "C:/Users/jessi/OneDrive - ufpr.br/week_temps/postdoc_UDESC/git/miniCursoR"


df <- read.csv("./data/exer/National Parks Visitation Data.csv")

setwd(path)

# Chamar e rodar um script R (*.R):
source(path)




####-- Arquivos --####
path <- "C:/Users/jessi/OneDrive/Desktop/miniCursoR/data"


# O que há nesse diretório? Quais arquivos?
dir() 
list.files()

# O que há em determinado diretório?
list.files(path, include.dirs = TRUE)

# Esse caminho é um arquivo '-f' ou uma pasta '-d'?
file_test('-f', path)

# Ler/Salvar um arquivo .csv:
df <- read.csv("./data/exer/National Parks Visitation Data.csv")

write.csv(df, "./output/dados_parques.csv")





###########################################
# Linguagem básica para operações em R ----
###########################################

#! representação decimal no R é o ponto “.” e não a vírgula “,”;
#! o símbolo # indica que tudo que está à direita dele é um comentário;
#! Inf - representa um número grande o suficiente que o computador não consegue representá-lo, ou um limite matemático;
#! NaN - Not a Number: representa indefinições matemáticas;
#! NA - Not Available: representa ausência de informação, inconsistência nos dados. Em operações matemáticas, resultam em NA;

#! Atribuiçao de variáveis: usa-se o operador '<-' ou '=';

#! O R é case sensitive, i.e., faz distinção entre letras maiúsculas e minúsculas;
#! Caracteres especiais, espaços e início numérico para os nomes das variáveis ou funções não são permitidos;
#! Não é recomendada a utilização de acentuação.



# ATALHOS ----

# Encerrar sessão: q()
# Reaproveitar comandos anteriores: no teclado ↑↓
# No “Console”, o termo [1] não  um resultado, apenas significa que a impressão do resultado ocupa uma linha do console.
# Duas ou mais operações podem ser feitas em uma mesma linha de código, basta colocar um ponto e vírgula “;” entre elas.

1 + 1; 2 + 2

####-- Classes de variáveis (tipos de dados) --####

# character (string, i.e., sequência de caracteres - usada para representar e armazenar informação textual)
texto <- 'hello' 
nome <- "hello" 

class(texto)
is.character(texto)



# Lista
ordem <- c('baixo', 'médio', 'alto')
numeros <- c('1', '1', '2')

numeros[3]
ordem[2]


ordem <- factor(c('baixo', 'médio', 'alto'))

ordem <- factor(c('baixo', 'médio', 'alto'),
                levels = c('baixo', 'médio', 'alto'))

ordem <- factor(c('2', '4', '1')) #ordem numérica




# factor (variáveis que podem ser ordenadas, i.e., categóricas - podem ser caracteres, números, inteiros...)
ordem <- factor(c('baixo', 'médio', 'alto'),
                levels = c('baixo', 'médio', 'alto')) #ordem alfabética

ordem <- factor(c('2', '4', '1')) #ordem numérica
ordem <- factor(c('2', '4', '1'),
                levels = c('2', '4', '1'))

is.factor(ordem)


# numeric (permite operações matemáticas)
valor <- 100
is.numeric(100)




valor <- as.character(1)
valor <- '1'
is.character(valor)


# integer (número do conjunto dos inteiros)
valor <- 1.2
is.integer(valor)

valor <- as.integer(1.2)
is.integer(valor)


library(tidyverse)
library(lubridate)

# Date (dates) e tempos ----
# datas (ano, mês, dia) são representadas pela classe Date.

#Tempos (ano, mês, dia, hora, minuto, segundo etc.) são representados pelas classes POSIXct ou POSIXlt

#Além disso, também existe a função as.POSIXct(), que é uma representação mais compacta de data e hora, geralmente preferida para cálculos, pois utiliza menos memória do que POSIXlt().

#ct significa tempo de calendário, ele armazena o número de segundos desde a origem.

#lt, ou hora local, mantém a data como uma lista de atributos de hora. ​

#Internamente, as datas são armazenadas como o número de dias desde 01/01/1970. Horas são armazenadas como o número de segundos desde 01/01/1970.


hoje <- "2025-12-15"
hoje <- ymd("2025-12-01")


# Timestamps (data e hora, POSIXct)
datetime <- "2025-12-01 00:01:00"
tz(datetime)



# Timestamps (data e hora, lubridate package)
datetime <- ymd_hms("2025-12-01 00:00:01", tz = "America/Sao_Paulo")

lubridate::tz(datetime)


## outra forma:
data_objeto <- as.POSIXct("01-01-2024 00:00:01", 
                          format = "%d-%m-%Y %H:%M:%S")


# Remoção de uma ou mais variáveis: 
rm(texto) 
ls()

# Remoção de todas as variáveis: 
rm(list=ls())
ls() 






####-- Chaining (Encadeamento) --####


#! O símbolo %>% - "pipe" - permite encadear operações e proporciona melhor legibilidade


df$Year 

mean(df$Visitors, na.rm = T)

df %>%
  select(Visitors) %>%
  colMeans(na.rm = T)
  


# Em caso de funções:

f(arg_1, arg_2, ..., arg_n) # é equivalente a:
arg1 %>% f(arg_2, ..., arg_n) # assim como a:
arg1 %>% f(., arg_2, ..., arg_n) # e à:
arg1 %>% f(arg_2, ., arg_3, ..., arg_n) # e a:


# E quando um dataframe 'df' é modificado por sucessivas operações (operation_1,... operation_n):

df <- operation_1(df$params_1)




df %>%
  operation_1(params_1) %>%
  operation_2(params_1) %>%
  ...                   %>%
  operation_n(params_1)





##########################
# Explorando os dados ----
##########################


####-- Como são os dados  --####

# Selecione as colunas de interesse:
df1 <- df %>%
  select(Year)

# Remover colunas:
df1 <- df %>%
  select(-Year)

# Visualizar as primeiras 'n' colunas:
df %>%
  head(3)

# Visualizar as últimas 'n' colunas:
df %>%
  tail(3)

# Sumário estatístico das colunas:
df %>%
  summary()


### Exemplo:
View(df)

df$Year

str(df)

df2 <- df %>%
  mutate(Year = mdy_hm(Year),
         ano = year(Year)) %>%
  select(-Year)



df %>% tail(3)


df1 <- df2 %>%
  filter(ano == 2004)


####-- Quais os tipos de dados  --####

# Tipos de dados de cada coluna
df %>%
  str()

# Número de linhas/colunas
df %>%
  NROW()

df %>%
  NCOL()


####-- Filtragem de dados  --####

df %>%
  filter('some_col' 'some_operation' 'some_value_or_list_or_col')


# Operação de comparação ----

df %>%
  filter(some_col == col_name) %>% # igual a
  filter(some_col != col_name) %>% # dierente de
  filter(some_col >= some_value) %>% # maior ou igual a
  filter(some_col == col_name & some_col >= some_value) %>% # 'igual a 'E' maior ou igual a
  filter(some_col == col_name | some_col == col_name2) %>% # igual a 'OU' igual a
  filter(!is.na(some_col)) %>% # selecionar valores faltantes
  filter(some_value %in% c(val_1, ..., val_n)) %>% # pertencem a
  filter(some_value %like%  'val') # padrão correspondente

# Colunas também podem ser filtradas com a função 'select_if'


# && avalia a 1ª condição e, somente se ela é verdadeira, então avaliará a segunda condição. Por outro lado, & avalia todas as condições. A ideia é a mesma para | e ||.

# Operadores lógicos (Boolean operators)
## & e  && #  ( e - conjunção);
## | e  || #  (ou - disjunção);
## ! # (não negação)
### O resultado é um valor lógico (TRUE ou FALSE).

TRUE & TRUE | FALSE & FALSE 
#TRUE Pela ordem de prioridade, as comparações dos dois operadores & são feitos primeiramente, para depois ser feita a comparação do operador |. Se a ordem de prioridade fosse a mesma para os três operados, então o resultado seria FALSE. 


# A ordem de prioridade de operadores lógicos é: 1º: ! 2º: & 3º: | 
