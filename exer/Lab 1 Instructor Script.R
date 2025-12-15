######################################################
# Baseado no material da Prof. Allison Horst
######################################################

######################################################
# Parte 1. Introdu????o ao ambiente do RStudio
######################################################

### A - Abrir o RStudio
### B - O ambiente (explicar janelas, scripts, arquivos, environment, etc.)
### C - Trabalhar no console (por que ?? r??pido e improvisado, e por que ?? um pesadelo para pesquisa e colabora????o)

######################################################
# Parte 2. Projetos
######################################################

### Pe??a para criarem um novo projeto (ap??s criar uma pasta para ESM 206/Labs/Lab Week 1) em File > New Project. 

### Quando voc?? abre o projeto, o R reconhece isso como seu diret??rio de trabalho. Observe que o caminho aparece na barra superior do RStudio, e quaisquer arquivos que voc?? salve/adicione s??o automaticamente inclu??dos nesse diret??rio de trabalho. Uma pasta para todo o projeto tamb??m ?? criada.

### Agora temos um projeto criado, e ele est?? esperando que realmente contribuamos com algo. Hoje vamos trabalhar em algo chamado SCRIPT. Ele ?? como um editor de texto (em oposi????o ao console sempre ativo) e s?? executa linhas de c??digo quando voc?? pede. Ele tamb??m permite manter um registro claro do trabalho que foi feito. 

######################################################
# Parte 3. Scripts - Bons h??bitos, organiza????o e outras coisas
######################################################

### A - Como scripts funcionam (+ coment??rios)
### B - Como executar c??digo em um script (+ atalhos)
### C - Eles come??am a criar seu pr??prio script usando uma ??tima organiza????o
### D - Pe??a para criarem algumas vari??veis - observe como elas aparecem na janela Environment quando armazenadas (crie para que eles vejam como salvar um script permite recuperar rapidamente vari??veis)
### E - Salvar o script que eles come??aram a criar (enfatizar a import??ncia de pastas organizadas DESDE J??)

### *** Lembre-se de mostrar como ativar a quebra de linha autom??tica: Tools > Global Options > Code > Soft Wrap R Source Files > Apply ***

######################################################
# Parte 4. Carregando o pacote 'tidyverse'
######################################################

### A - Explicar brevemente o que s??o pacotes (e por que eles n??o s??o carregados automaticamente)
### B - Carregar o pacote tidyverse

library(tidyverse)

######################################################
# Parte 5. Carregando dados de arquivos .csv
######################################################

### Carregar arquivos no RStudio ?? F??CIL se voc?? estiver trabalhando em um projeto. Tudo o que voc?? precisa fazer ?? arrastar e soltar o arquivo (geralmente um arquivo .csv) na pasta do projeto.

# Pe??a para arrastarem e soltarem o arquivo na pasta do projeto e observe que ele aparece automaticamente na aba 'Files' do RStudio. Isso acontece porque o R sabe que ele foi adicionado ao nosso diret??rio de trabalho. 

# Uma vez que est?? no projeto, ?? f??cil carregar usando read_csv().

np_visits <- read_csv("National Park Visitation Data.csv") # Certifique-se de que eles se acostumem a adicionar coment??rios ap??s cada linha de c??digo!

######################################################
# Parte 5. Explora????o inicial dos dados
######################################################

## SEMPRE. EXPLORE. SEUS. DADOS. ##

names(np_visits) # Mostra os nomes das vari??veis (colunas)
dim(np_visits) # Dimens??es do conjunto de dados
class(np_visits) # Classe do objeto de dados
head(np_visits) # Mostra as primeiras 6 linhas do conjunto de dados
tail(np_visits) # Mostra as ??ltimas 6 linhas do conjunto de dados

# Quer saber como uma fun????o funciona?

?names # Um ??nico ponto de interroga????o abre a documenta????o do R para essa fun????o
??name # Mostra todas as fun????es que podem conter esse termo

# Colunas individuais podem ser acessadas usando '$'
Reg <- np_visits$Region # Um vetor contendo apenas as informa????es da coluna 'Region' do NPDF

MaxVis <- max(np_visits$Visitors, na.rm = TRUE) # Encontra o valor m??ximo da coluna 'Visitors' no data frame NPDF (isso ?? uma boa forma de mostrar o que pode acontecer se houver valores NA)

#######################################################
# Parte 6. Manipula????o b??sica de dados (fun????es do dplyr)
#######################################################

df1 <- select(np_visits, State:YearRaw) # Seleciona apenas as colunas de State at?? YearRaw no data frame NPDF, armazenando como um novo data frame 'df1'
View(df1) # Lembre-se de olhar os dados!

df2 <- filter(df1, State == "CA" & Type == "National Park" & YearRaw >= 1950) # Filtra para manter apenas linhas em que o estado ?? 'CA' e o tipo ?? 'National Park' E apenas anos maiores ou iguais a 1950, armazenando como um novo subconjunto 'df2'
View(df2) # Sempre olhe!

df3 <- arrange(df2, Code, YearRaw) # Organiza os dados primeiro pela ordem alfab??tica da coluna 'Code' e DEPOIS pela ordem crescente da coluna YearRaw
View(df3)

df4 <- mutate(df3, kVis = Visitors/1000) # Adiciona uma NOVA coluna chamada 'kVis' (milhares de visitantes) ao 'df3', que ?? a coluna Visitors dividida por 1000
View(df4)

df5 <- filter(df4, YearRaw != "Total") # Remove quaisquer valores 'Total' da coluna YearRaw (!= significa "N??O corresponde")
# Verificar a classe de cada coluna
summary(df5) # Ops. YearRaw est?? armazenado como caractere (porque tinha valores 'Total'). Queremos que seja num??rico para usar facilmente como eixo x. 

df5$YearRaw <- as.numeric(df5$YearRaw) # Converte a coluna YearRaw de df5 para 'numeric' em vez de 'character'
class(df5$YearRaw) # Verifique! Agora retorna 'numeric'. Viva!


### Isso pode parecer um pouco ineficiente. Sim, existe uma forma melhor. Ela se chama "piping" e permite escrever um c??digo mais enxuto para opera????es sequenciais em um data frame. 

#####################################################
# Parte 7. Introdu????o ao piping
#####################################################

# No exemplo acima, escrevemos uma linha de c??digo separada para cada opera????o de manipula????o dos dados de parques nacionais. Isso ?? bom em alguns aspectos, mas cansativo em outros. 

# E se quis??ssemos manter apenas parques nacionais em Utah, excluir qualquer valor "Total" na coluna 'YearRaw', adicionar uma coluna em milh??es de visitantes e depois organizar do maior para o menor E por tipo? Poder??amos seguir o mesmo processo acima ou usar piping. 

# Explicar o operador pipe %>%  (command + shift + m)

# Pense nisso como uma forma em c??digo de dizer "e depois..."

utah_np <- np_visits %>% 
  select(Name, Visitors, YearRaw, State, Type) %>% 
  filter(YearRaw != "Total") %>% 
  filter(State == "UT", Type == "National Park") %>% 
  mutate(mill_vis = Visitors/1000000)

utah_np


######################################################### 
# Parte 8. Nosso primeiro gr??fico com ggplot
######################################################

# Vamos criar um gr??fico de visita????o aos parques (em milhares de visitantes) ao longo dos anos, com a cor dependendo do parque mostrado. 

# Tr??s coisas que voc?? deve dizer ao R para criar um gr??fico no ggplot: 
# (1) Que voc?? est?? usando ggplot
# (2) Quais dados voc?? est?? usando (incluindo o que ser?? x e o que ser?? y)
# (3) Que tipo de gr??fico voc?? quer criar
# Tudo depois disso ?? extra para deix??-lo bonito

VisitorGraph <- ggplot(df5, aes(x = YearRaw, y = kVis)) +
  geom_point()

windows() # em um PC ser?? windows()!
VisitorGraph

# Isso j?? ?? legal para uma primeira tentativa, mas definitivamente n??o ?? um gr??fico finalizado. Vamos come??ar a adicionar camadas e mudar o tipo de linha para obter um gr??fico mais refinado. 


VisitorGraph2 <- ggplot(df5, aes(x = YearRaw, y = kVis)) + # Diz ao R quais dados usar
  geom_point(aes(colour = Code)) + # Diz ao ggplot para criar um gr??fico de dispers??o
  geom_line(aes(colour = Code)) + # ...e depois adicionar um gr??fico de linhas
  ggtitle("California National Parks Visitation\n1950 - 2016") + # Adiciona um t??tulo
  xlab("\nYear") + # \n adiciona uma linha em branco antes do r??tulo
  ylab("Thousands of Visitors\n") + # Aqui depois do r??tulo
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) + # Limpa a ??rea do gr??fico (remove grades, fundo, etc.)
  scale_x_continuous(breaks = c(1950,1960,1970,1980,1990,2000,2010,2020)) # Define onde os marcadores do eixo x aparecem

windows() # em um PC ser?? windows()!
VisitorGraph2

# Quer criar um gr??fico interativo? Use plotly! Omitido em 2018 porque os alunos ainda n??o instalaram plotly...

# library(plotly)
# ggplotly(VisitorGraph2)

######################################################
# Parte 8. Outro gr??fico ggplot (n??o feito no laborat??rio)
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
