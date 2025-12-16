######################################################
# Baseado no material da Prof. Allison Horst
######################################################

######################################################
# Parte 1. Introducaoo ao ambiente do RStudio
######################################################

### A - Abrir o RStudio
### B - O ambiente (explicar janelas, scripts, arquivos, environment, etc.)
### C - Trabalhar no console (por que é rápido e improvisado, e por que é um pesadelo para pesquisa e colaboracaoo)

######################################################
# Parte 2. Projetos
######################################################

### Pe??a para criarem um novo projeto (apóss criar uma pasta para ESM 206/Labs/Lab Week 1) em File > New Project. 

### Quando voc?? abre o projeto, o R reconhece isso como seu diretório de trabalho. Observe que o caminho aparece na barra superior do RStudio, e quaisquer arquivos que voce salve/adicione sao automaticamente incluidos nesse diretorio de trabalho. Uma pasta para todo o projeto tambem e criada.

### Agora temos um projeto criado, e ele est?? esperando que realmente contribuamos com algo. Hoje vamos trabalhar em algo chamado SCRIPT. Ele e como um editor de texto (em oposicao ao console sempre ativo) e so executa linhas de codigo quando voce pede. Ele tambem permite manter um registro claro do trabalho que foi feito. 

######################################################
# Parte 3. Scripts - Bons habitos, organizacao e outras coisas
######################################################

### A - Como scripts funcionam (+ comentarios)
### B - Como executar codigo em um script (+ atalhos)
### C - Eles comecam a criar seu proprio script usando uma otima organizacao
### D - Peca para criarem algumas variaveis - observe como elas aparecem na janela Environment quando armazenadas (crie para que eles vejam como salvar um script permite recuperar rapidamente variaveis)
### E - Salvar o script que eles comecaram a criar (enfatizar a importancia de pastas organizadas DESDE JA)

### *** Lembre-se de mostrar como ativar a quebra de linha automatica: Tools > Global Options > Code > Soft Wrap R Source Files > Apply ***

######################################################
# Parte 4. Carregando o pacote 'tidyverse'
######################################################

### A - Explicar brevemente o que sao pacotes (e por que eles nao sao carregados automaticamente)
### B - Carregar o pacote tidyverse

library(tidyverse)

######################################################
# Parte 5. Carregando dados de arquivos .csv
######################################################

### Carregar arquivos no RStudio e FACIL se voce estiver trabalhando em um projeto. Tudo o que voce precisa fazer e arrastar e soltar o arquivo (geralmente um arquivo .csv) na pasta do projeto.

# Peca para arrastarem e soltarem o arquivo na pasta do projeto e observe que ele aparece automaticamente na aba 'Files' do RStudio. Isso acontece porque o R sabe que ele foi adicionado ao nosso diretorio de trabalho. 

# Uma vez que esta no projeto, e facil carregar usando read_csv().
getwd()
np_visits <- read.csv("./data/exer/National Parks Visitation Data.csv") # Certifique-se de que eles se acostumem a adicionar comentarios apos cada linha de codigo!

######################################################
# Parte 5. Explorando os dados
######################################################

## SEMPRE. EXPLORE. SEUS. DADOS. ##

names(np_visits) # Mostra os nomes das variaveis (colunas)
dim(np_visits) # Dimensoes do conjunto de dados
class(np_visits) # Classe do objeto de dados
head(np_visits) # Mostra as primeiras 6 linhas do conjunto de dados
tail(np_visits) # Mostra as ultimas 6 linhas do conjunto de dados

# Quer saber como uma funcao funciona?

?names # Um unico ponto de interrogaco abre a documentacao do R para essa funcao
??name # Mostra todas as funcoes que podem conter esse termo

# Colunas individuais podem ser acessadas usando '$'
Reg <- np_visits$Region # Um vetor contendo apenas as informacoes da coluna 'Region' do NPDF

MaxVis <- max(np_visits$Visitors, na.rm = TRUE) # Encontra o valor maximo da coluna 'Visitors' no data frame NPDF (isso e uma boa forma de mostrar o que pode acontecer se houver valores NA)

#######################################################
# Parte 6. Manipulacao basica de dados (funcoes do dplyr)
#######################################################

df1 <- select(np_visits, State:YearRaw) # Seleciona apenas as colunas de State ate YearRaw no data frame NPDF, armazenando como um novo data frame 'df1'
View(df1) # Lembre-se de olhar os dados!

df2 <- filter(df1, State == "CA" & Type == "National Park" & YearRaw >= 1950) # Filtra para manter apenas linhas em que o estado e 'CA' e o tipo e 'National Park' E apenas anos maiores ou iguais a 1950, armazenando como um novo subconjunto 'df2'
View(df2) # Sempre olhe!

df3 <- arrange(df2, Code, YearRaw) # Organiza os dados primeiro pela ordem alfabetica da coluna 'Code' e DEPOIS pela ordem crescente da coluna YearRaw
View(df3)

df4 <- mutate(df3, kVis = Visitors/1000) # Adiciona uma NOVA coluna chamada 'kVis' (milhares de visitantes) ao 'df3', que e a coluna Visitors dividida por 1000
View(df4)

df5 <- filter(df4, YearRaw != "Total") # Remove quaisquer valores 'Total' da coluna YearRaw (!= significa "NAO corresponde")
# Verificar a classe de cada coluna
summary(df5) # Ops. YearRaw esta armazenado como caractere (porque tinha valores 'Total'). Queremos que seja numerico para usar facilmente como eixo x. 

df5$YearRaw <- as.numeric(df5$YearRaw) # Converte a coluna YearRaw de df5 para 'numeric' em vez de 'character'
class(df5$YearRaw) # Verifique! Agora retorna 'numeric'. Viva!


### Isso pode parecer um pouco ineficiente. Sim, existe uma forma melhor. Ela se chama "piping" e permite escrever um codigo mais enxuto para operacoes sequenciais em um data frame. 

#####################################################
# Parte 7. Introducao ao piping
#####################################################

# No exemplo acima, escrevemos uma linha de codigo separada para cada operacao de manipulacao dos dados de parques nacionais. Isso e bom em alguns aspectos, mas cansativo em outros. 

# E se quisessemos manter apenas parques nacionais em Utah, excluir qualquer valor "Total" na coluna 'YearRaw', adicionar uma coluna em milhoes de visitantes e depois organizar do maior para o menor E por tipo? Poderiamos seguir o mesmo processo acima ou usar piping. 

# Explicar o operador pipe %>%  (command + shift + m)

# Pense nisso como uma forma em codigo de dizer "e depois..."

utah_np <- np_visits %>% 
  select(Name, Visitors, YearRaw, State, Type) %>% 
  filter(YearRaw != "Total") %>% 
  filter(State == "UT", Type == "National Park") %>% 
  mutate(mill_vis = Visitors/1000000)

utah_np


######################################################### 
# Parte 8. Nosso primeiro grafico com ggplot
######################################################

# Vamos criar um grafico de visitacao aos parques (em milhares de visitantes) ao longo dos anos, com a cor dependendo do parque mostrado. 

# Tres coisas que voce deve dizer ao R para criar um grafico no ggplot: 
# (1) Que voce esta usando ggplot
# (2) Quais dados voce esta usando (incluindo o que sera x e o que sera y)
# (3) Que tipo de grafico voce quer criar
# Tudo depois disso e extra para deixa-lo bonito

VisitorGraph <- ggplot(df5, aes(x = YearRaw, y = kVis)) +
  geom_point()

windows() # em um PC sera windows()!
VisitorGraph

# Isso ja e legal para uma primeira tentativa, mas definitivamente nao e um grafico finalizado. Vamos comecar a adicionar camadas e mudar o tipo de linha para obter um grafico mais refinado. 


VisitorGraph2 <- ggplot(df5, aes(x = YearRaw, y = kVis)) + # Diz ao R quais dados usar
  geom_point(aes(colour = Code)) + # Diz ao ggplot para criar um grafico de dispersao
  geom_line(aes(colour = Code)) + # ...e depois adicionar um grafico de linhas
  ggtitle("California National Parks Visitation\n1950 - 2016") + # Adiciona um titulo
  xlab("\nYear") + # \n adiciona uma linha em branco antes do rotulo
  ylab("Thousands of Visitors\n") + # Aqui depois do rotulo
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) + # Limpa a area do grafico (remove grades, fundo, etc.)
  scale_x_continuous(breaks = c(1950,1960,1970,1980,1990,2000,2010,2020)) # Define onde os marcadores do eixo x aparecem

windows() # em um PC!
VisitorGraph2

# Quer criar um grafico interativo? Use plotly! 

# library(plotly)
# ggplotly(VisitorGraph2)

######################################################
# Parte 8. Outro grafico ggplot (nao feito no laboratorio)
######################################################

VisBoxplot <- ggplot(df5, aes(x = Code, y = kVis)) +
  geom_boxplot(aes(fill = Code)) +
  theme_bw() +
  ggtitle("CA National Park Visitation (1950 - 2016)") +
  xlab("National Park") +
  ylab("Thousands of Visitors") +
  scale_x_discrete(breaks = c("CHIS","DEVA","JOTR","KICA","LAVO","PINN","REDW","SEQU","YOSE"), labels = c("Channel Islands","Death Valley","Joshua Tree","Kings Canyon","Lassen Volcanic","Pinnacles","Redwoods","Sequoia","Yosemite")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45)) 


windows() # Lembre-se: mudar para windows() em um PC
VisBoxplot
