# Funcoes para importar arquivos ----

readr::read_csv()
read.csv()


library(data.table)
data.table::fread()


# Criando dataframes ----

datas <- c(
  "2013-01-01", "2013-01-02", "2013-01-03", "2013-01-04", "2013-01-05",
  "2013-01-06", "2013-01-07", "2013-01-08", "2013-01-09", "2013-01-10",
  "2013-01-11", "2013-01-12", "2013-01-13", "2013-01-14", "2013-01-15"
)

cidade <- rep("Santa Maria", 15)

tar <- c(31, 35, 21, 23, 33, 17, 18, 16, 34, 27, 15, 28, 22, 29, 32)


dados <- data.frame(datas, cidade, tar)




dados <- data.frame(
  datas = c(
    "2013-01-01", "2013-01-02", "2013-01-03", "2013-01-04", "2013-01-05",
    "2013-01-06", "2013-01-07", "2013-01-08", "2013-01-09", "2013-01-10",
    "2013-01-11", "2013-01-12", "2013-01-13", "2013-01-14", "2013-01-15"
  ),
  cidade = rep("Santa Maria", 15),
  tar = c(31, 35, 21, 23, 33, 17, 18, 16, 34, 27, 15, 28, 22, 29, 32)
)




# Criando funções ----

# Criando a nossa função!
# Área de um retângulo


area_ret <- function(lado1, lado2){
  # O que a sua função faz
  area <- lado1*lado2
  
  # O que a função retorna
  return(area)
}



area_ret(5)
area_ret(5, 10)



# Função condicional ----


# Estruturas condicionais (ifelse)
x <- 10

?ifelse

ifelse(x < 100, 
       "X é menor que 100", 
       "X é maior ou igual a 100")

x <- 1000

ifelse(x < 100, 
       "X é menor que 100", 
       "X é maior ou igual a 100")

ifelse(1, 
       "X é menor que 100", 
       "X é maior ou igual a 100")

ifelse(0, 
       "X é menor que 100", 
       "X é maior ou igual a 100")





# Loops (for e while) - não são funções ----
# for (sabemos como queremos iterar)
help(tidyverse)

for (variable in vector) {
  
}

for(i in 1:5){
  print(i)
}

vetor_lado1 <- c(10, 20, 30, 40, 50)

vetor_lado2 <- c(5, 10, 15, 20, 25)


i <- 1

for(i in 1:5){
  x <- area_ret(lado1 = vetor_lado1[i], lado2 = vetor_lado2[i])
  print(x)
}



retangulos <- data.frame(vetor_lado1, vetor_lado2)


retangulos <- retangulos %>%
  mutate(area = vetor_lado1*vetor_lado2)



for(x in c("texto inicial", "texto do meio", "texto final")){
  print(x)
}


# while (não sabemos exatamente quantas vezes queremos iterar)
i <- 0

while (condition) {
  
}



while(i <= 5){
  print(i)
  i <- i + 1
}


# Loop infinito
i <- 0

while(i <= 5){
  print(i)
  i <- i - 1
}



# Comum fazermos em modelagens!
erro <- 10
iter <- 1
#set.seed(9)
#set.seed(0)


while(erro >= 0.01 & iter <= 100){
  
  # Pintar iteração
  print(paste0(iter, ": ", erro))
  
  # Fazer alguma função qualquer
  erro <- runif(1, min = 0, max = 1)
  iter <- iter + 1
}



#######################################################
########## Visualizacoes ----




