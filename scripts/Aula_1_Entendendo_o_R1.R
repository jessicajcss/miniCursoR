# Visualização 
## https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/
## https://emm-concepts.com/Eskdale_flow_algorithms.html


################################
# Gerenciamento de arquivos ----
################################


####-- Caminho --####

# Qual o diretório em que você está trabalhando?
getwd() 

# Definir um caminho:
path <- "./" # '<-' ou '=' podem ser usados, mas '<-' funciona exclusivamente para atribuição de objetos (variáveis)

# Chamar e rodar um script R (*.R):
source(path)




####-- Arquivos --####

# O que há nesse diretório? Quais arquivos?
dir() 
list.files()

# O que há em determinado diretório?
list.files(path, include.dirs = TRUE)

# Esse caminho é um arquivo '-f' ou uma pasta '-d'?
file_test('-d', path)

# Ler/Salvar um arquivo .csv:
read.csv(path_to_csv_file)
write.csv(df, path_to_csv_file)





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
#! Caracteres especiais, espaços e início numérico para os nomes das variáveis ou funções não são permitidos;
#! Não é recomendada a utilização de acentuação.


# ATALHOS ----

# Encerrar sessão: q()
# Reaproveitar comandos anteriores: no teclado ↑↓
# No “Console”, o termo [1] não  um resultado, apenas significa que a impressão do resultado ocupa uma linha do console.
# Duas ou mais operações podem ser feitas em uma mesma linha de código, basta colocar um ponto e vírgula “;” entre elas.



####-- Classes de variáveis (tipos de dados) --####

# character (string, i.e., sequência de caracteres - usada para representar e armazenar informação textual)
texto <- 'hello' 
nome <- "hello" 

class(texto)
is.character(texto)


# factor (variáveis que podem ser ordenadas, i.e., categóricas - podem ser caracteres, números, inteiros...)
ordem <- factor(c('baixo', 'médio', 'alto')) #ordem alfabética

ordem <- factor(c('2', '4', '1')) #ordem numérica
ordem <- factor(c('2', '4', '1'),
                levels = c('2', '4', '1'))

is.factor(ordem)


# numeric (permite operações matemáticas)
valor <- 100
is.numeric(100)

valor <- as.numeric(as.character('texto'))
is.numeric(valor)


# integer (número do conjunto dos inteiros)
valor <- 1.2
is.integer(valor)

valor <- as.integer(1.2)
is.integer(valor)


# Date (dates)
hoje <- "2025-12-01"

# Timestamps (data e hora, POSIXct)
datetime <- "2025-12-01 00:01:00"
lubridate::tz(datetime)

datetime <- lubridate::ymd_hms("2025-12-01 00:01:00", tz = "America/Sao_Paulo")
lubridate::tz(datetime)



# Remoção de uma ou mais variáveis: 
rm(texto, horas) 
ls()

# Remoção de todas as variáveis: 
rm(list=ls())
ls() 






####-- Chaining (Encadeamento) --####


#! O símbolo %>% - "pipe" - permite encadear operações e proporciona melhor legibilidade


# Em caso de funções:

f(arg_1, arg_2, ..., arg_n) # é equivalente a:
arg1 %>% f(arg_2, ..., arg_n) # assim como a:
arg1 %>% f(., arg_2, ..., arg_n) # e à:
arg1 %>% f(arg_2, ., arg_3, ..., arg_n) # e a:


# E quando um dataframe 'df' é modificado por sucessivas operações (operation_1,... operation_n):

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
df %>%
  select(col_list)

# Remover colunas:
df %>%
  select(-col_list)

# Visualizar as primeiras 'n' colunas:
df %>%
  head(n)

# Visualizar as últimas 'n' colunas:
df %>%
  tail(n)

# Sumário estatístico das colunas:
df %>%
  summary()


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
  filter(is.na(some_col)) %>% # selecionar valores faltantes
  filter(some_value %in% c(val_1, ..., val_n)) %>% # pertencem a
  filter(some_value %like%  'val') # padrão correspondente

# Colunas também podem ser filtradas com a função 'select_if'


# && avalia a 1ª condição e, somente se ela é verdadeira, então avaliará a segunda condição. Por outro lado, & avalia todas as condições. A ideia é a mesma para | e ||.

# Operadores lógicos (Boolean operators)
## & e  && 	#  ( e - conjunção);
## | e  || #  (ou - disjunção);
## ! # (não negação)
### O resultado é um valor lógico (TRUE ou FALSE).

TRUE & TRUE | FALSE & FALSE 
#TRUE Pela ordem de prioridade, as comparações dos dois operadores & são feitos primeiramente, para depois ser feita a comparação do operador |. Se a ordem de prioridade fosse a mesma para os três operados, então o resultado seria FALSE. 


# A ordem de prioridade de operadores lógicos é: 1º: ! 2º: & 3º: | 
  