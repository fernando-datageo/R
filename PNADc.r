#### Carregando o banco de dados ####

# Passo 1: selecionar o diretório de trabalho (working directory)
## Session > Set Working Directory > Choose Directory

setwd("C:/Users/User/Desktop/PNADc")


#### Instalando e carregando as bibliotecas ####

#PNADcIBGE: Responsável por trazer a base de dados

if(!require(PNADcIBGE))
  install.packages("PNADcIBGE ")
library(PNADcIBGE)


#psych: Fornecer os valores:
  #média, mediana, quartis e valores mín e máx

if(!require(psych))
  install.packages("psych")
library(psych)


#dplyr: Agrupar os valores criados 

if(!require(dplyr))
  install.packages("dplyr")
library(dplyr)


#esquisse: Auxilia na exploração e extração das informações

if(!require(esquisse))
  install.packages("esquisse")
library(esquisse)


#ggplot2: Plotar as informações

if(!require(ggplot2))
  install.packages("ggplot2")
library(ggplot2)


#### Tratando os dados ####

#Extraindo as variáveis da base de dados (PNADcIBGE)

dadosPNADc <- get_pnadc(year = 2020, quarter = 4, vars=c("VD4008","VD4020","V3009A"))


#Filtrar as variáveis importadas

varPNADc<- dadosPNADc$variables


#Eliminar colnas desnecessárias

varPNADc <- subset(varPNADc, select = -c(Ano, Trimestre, UPA, Estrato, V1008, V1027, V1029, posest, V2003, Habitual, Efetivo))


#Eliminar os valores NA

varPNADc2 <- na.omit(varPNADc)


#Renomear colunas (dplyr)

varPNADc2 <- rename(varPNADc2, Escolaridade = V3009A, Setor = VD4008, Renda = VD4020)


#Cria um novo arquivo CSV apenas com um uma variavel escolhida dentro do setor

write.csv2(subset(varPNADc2, Setor == "Empregado no setor privado"), "Empregado no setor privado.csv",  row.names = FALSE)
write.csv2(subset(varPNADc2, Setor == "Empregado no setor público (inclusive servidor estatutário e militar)"), "Empregado no setor público.csv",  row.names = FALSE)
write.csv2(subset(varPNADc2, Setor == "Trabalhador familiar auxiliar"), "Empregado no setor privado.csv",  row.names = FALSE)
write.csv2(subset(varPNADc2, Setor == "Conta-própria"), "Conta-própria.csv",  row.names = FALSE)
write.csv2(subset(varPNADc2, Setor == "Empregador"), "Empregador.csv",  row.names = FALSE)
write.csv2(subset(varPNADc2, Setor == "Trabalhador doméstico"), "Trabalhador doméstico.csv",  row.names = FALSE)


#Importa o arquivo CSV criado

privado <- read.csv2('Empregado no setor privado.csv', stringsAsFactors = T)
publico <- read.csv2('Empregado no setor público.csv', stringsAsFactors = T)
familiar <- read.csv2('Trabalhador familiar auxiliar.csv', stringsAsFactors = T)
propia <- read.csv2('Conta-própria.csv', stringsAsFactors = T)
empregador <- read.csv2('Empregador.csv', stringsAsFactors = T)
domestico <- read.csv2('Trabalhador doméstico.csv', stringsAsFactors = T)


#Explorar e gerar os gráficos
esquisser(privado)
esquisser(publico)
esquisser(familiar)
esquisser(propia)
esquisser(empregador)
esquisser(domestico)


#Exemplo de gráfico "Setor Público - Escolaridade vs Renda"

library(ggplot2)

ggplot(publico) +
  aes(x = Renda, y = Escolaridade) +
  geom_boxplot(shape = "circle", fill = "#112446") +
  labs(x = "Renda", y = "Escolaridade", title = "Setor Público", subtitle = "Escolaridade vs Renda") +
  theme_minimal()


#Fim