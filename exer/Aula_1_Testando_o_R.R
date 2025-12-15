# Conceitos Básicos ####

## Operações Básicas ####
# O R funciona como uma calculadora muito potente..
1 + 2
12 * 5
12 ^ 4
2 / 2
11 %% 3
sqrt(9)

# Operações matemáticas com vetores e escalares
c(1, 2, 3, 4, 5)
2*c(1, 2, 3, 4, 5)
2 + c(1, 2, 3, 4, 5)

# Entre vetores
c(1, 3, 5, 7, 9) + c(2, 4, 6, 8, 10)
c(1, 3, 5, 7) * c(2, 4, 6, 8)
c(1, 3, 5, 7) * t(c(2, 4, 6, 8))

# Vetores com tamanhos diferentes
c(1, 3, 5) * c(2, 4, 6, 8)
c(1, 3, 5, 7) * c(2, 4, 6)

# Operacções matriciais (`%*%`) - o que é muito importante na vetorização!
c(1, 3, 5, 7) %*% t(c(2, 4, 6, 8))
t(c(2, 4, 6, 8)) %*% c(1, 3, 5, 7)

# Variáveis
x <- 2
x
-8 -> x
x
x <- "texto"
x
x = 2

# Operadores lógicos
x == 2
x == 3
x != 2
x < 3
x >= 2

# Objetos do R (classes)
x <- 2
class(x)

y <- "oi"
class(y)

z <- TRUE
class(z)

x <- 2L
class(x)


# Classes em vetores
x <- c(1, 2, 3, 4)
class(x)

y <- c(FALSE, TRUE, T, F)
y
print(y)
class(y)

x <- c("ola", "bom", "dia", "programadores")
x
class(x)


# Fatores
x <- factor(c("normal", "atenção", "alerta", "inundação",
              "inundação severa", "inundação", "atenção",
              "normal", "inundação", "normal", "alerta"))
x
table(x)

y <- factor(c("normal", "atenção", "alerta", "inundação",
              "inundação severa", "inundação", "atenção",
              "normal", "inundação", "normal", "alerta"),
            levels = c("seca", "normal", "atenção", "alerta", "inundação", "inundação severa"),
            ordered = T)
y
y <= "alerta"


# Coerção de variáveis
x <- c("ola", 1, "dia", 2)
x
class(x)
x * 2

x <- as.character(3)
x
class(x)
x + 1

x <- as.numeric(TRUE)
x

x <- as.numeric(FALSE)
x

x <- as.numeric(c("ola", 1, "dia", 2))
x
class(x)

# Tem outros tipos de funções para coerção
# `as.numeric()`
# `as.character()`
# `as.Date()`
# `as.logical()`
# `as.factor()`
# `as.complex()`


# Sequências
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
x

x <- 1:10
x

x <- seq(1, 10)
x

x <- seq(1, 10, 4)
x


# Indexação com colchetes!
x <- 11:20
x
x[1]
x[c(1, 2, 5)]
x[-3]

# Operações em ou com vetores
x <- c(1:5)
y <- c(1:4)
x + y
x > 6
sum(x > 4)
x[x > 4]

# Outros operadores lógicos!
x > 2 & x < 4
x <= 2 | x >= 4


# Outros tipos de dados (Data Frames, matrizes e listas)
# Matrizes
m <- matrix(nrow = 2, ncol = 3); m
attributes(m)

# Matriz a partir de vetores
m <- matrix(x, nrow = 2, ncol = 5); m
m <- matrix(x, nrow = 2, ncol = 5, byrow = TRUE); m

# Indexacao com matrizes [linha, coluna]
m <- matrix(1:9, nrow = 3); m
m[1, 2]
m[2,]
m[,3]

# Selecionar elementos de matrizes quadradas
lower.tri(m)
upper.tri(m)

# Selecionar elementos de matrizes quadradas
m; m[lower.tri(m)]
m; diag(m)


# Matriz a partir de vetores (rbind e cbind)
x <- c(1:10)
y <- seq(110, 200, 10)
uniao_colunas <- cbind(x, y)
uniao_colunas
dim(uniao_colunas)

uniao_linhas <- rbind(x, y)
uniao_linhas
dim(uniao_linhas)


# Data Frames
DF <- data.frame(x = c(1:3), coluna_2 = c("A", "B", "C"))
DF
class(DF)

m_df <- as.data.frame(m)
m_df
class(m_df)


# Listas
x <- list(1, "Ola", 1+5i, TRUE, 4L)
x

x <- list(c(1,2,3), m, DF, 1+5i, TRUE, 4L)
x[[1]]
x[[1]][3]

x[[2]][3, 3]

x[[6]]
x[[6]] * 10


# Programação Básica ####
# Funções
sqrt(64)
seq(1, 10)
log(10)

# Entender os argumentos de uma função
args(log)
?log
help(log)

log(100)
log(x = 100, base = 10)
log(100, 10)
log(base = 10, x = 100)

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


# Estruturas condicionais (ifelse)
x <- 10
?ifelse
ifelse(x < 100, "X é menor que 100", "X é maior ou igual a 100")

x <- 1000
ifelse(x < 100, "X é menor que 100", "X é maior ou igual a 100")

ifelse(1, "X é menor que 100", "X é maior ou igual a 100")
ifelse(0, "X é menor que 100", "X é maior ou igual a 100")

# Podemos usar só o if
x <- 3.7
if(class(x) != "integer") x <- as.integer(x)
class(x)

x <- 3.7
if(class(x) != "integer") x <- as.integer(round(x))
class(x)


# Loops (for e while) - não são funções
# for (sabemos como queremos iterar)
help(tidyverse)

for (variable in vector) {
  
}

for(i in 1:5){
  print(i)
}

vetor_lado1 <- c(10, 20, 30, 40, 50)
vetor_lado2 <- c(5, 10, 15, 20, 25)
for(i in 1:5){
  x <- area_ret(lado1 = vetor_lado1[i], lado2 = vetor_lado2[i])
  print(x)
}


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

