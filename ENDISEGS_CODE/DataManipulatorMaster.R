#Created by: Lars Daniel Johansson Niño, data science undergrad at ITAM
#Last edited date: 12/26/22
#Purpose: Handle data 

paste("Hello data manipulator!")
library(dplyr)
library(tidyverse)
library(plyr)
library(stringr)

#The code is divided into the following sections for
#better order of use
    #1.) Computer file pahts and other generalizations
    #2.) Data for: Percentage of the population that responded to ENDISEG


#1.)Computer file paths and other generalizations

#Computer file path for DataToBeAnalized
dataToBeAnalized <- "/Users/larsdanieljohanssonnino/Desktop/ResearchCode/ENDISEG/DataToBeAnalized"

#Computer file paths for ENDISEG 2021
path_endiseg2021 <- "/Users/larsdanieljohanssonnino/Desktop/ResearchCode/ENDISEG/Data"
#Details of data base design can be found at:
#"C:\Users\Dani Johansson\Desktop\DATA N RESEARCH\ENDISEG\Endiseg2021\Descripciones"

path_tapart_a_2021 <- paste(path_endiseg2021, "/conjunto_de_datos_endiseg_2021_csv/conjunto_de_datos_tapart_a_endiseg_2021/conjunto_de_datos/conjunto_de_datos_tapart_a_endiseg_2021.csv", sep = "")
path_tapart_b_2021 <- paste(path_endiseg2021, "/conjunto_de_datos_endiseg_2021_csv/conjunto_de_datos_tapart_b_endiseg_2021/conjunto_de_datos/conjunto_de_datos_tapart_b_endiseg_2021.csv", sep = "")
path_tmodulo_2021 <-  paste(path_endiseg2021, "/conjunto_de_datos_endiseg_2021_csv/conjunto_de_datos_tmodulo_endiseg_2021/conjunto_de_datos/conjunto_de_datos_tmodulo_endiseg_2021.csv", sep = "")
path_tsdem_2021 <-    paste(path_endiseg2021, "/conjunto_de_datos_endiseg_2021_csv/conjunto_de_datos_tsdem_endiseg_2021/conjunto_de_datos/conjunto_de_datos_tsdem_endiseg_2021.csv", sep = "")
path_tvivienda_2021<- paste(path_endiseg2021, "/conjunto_de_datos_endiseg_2021_csv/conjunto_de_datos_tvivienda_endiseg_2021/conjunto_de_datos/conjunto_de_datos_tvivienda_endiseg_2021.csv", sep = "")

#Computer file paths for ENDISEG WEB 2022
path_endisegweb2022 <- "/Users/larsdanieljohanssonnino/Desktop/ResearchCode/ENDISEG/Data/conjunto_de_datos_endiseg_web_2022_csv"
#Details of data base design can be found at:
#"C:\Users\Dani Johansson\Desktop\DATA N RESEARCH\ENDISEG\EndisegWEB2022\Descripciones"

path_tapart_a_2022 <- paste(path_endisegweb2022,"/conjunto_de_datos_tapart_a_endiseg_web_2022/conjunto_de_datos/conjunto_de_datos_tapart_a_endiseg_web_2022.csv",sep = "")
path_tapart_b_2022 <- paste(path_endisegweb2022,"/conjunto_de_datos_tapart_b_endiseg_web_2022/conjunto_de_datos/conjunto_de_datos_tapart_b_endiseg_web_2022.csv",sep = "")
path_tmodulo_2022 <-  paste(path_endisegweb2022, "/conjunto_de_datos_tmodulo_endiseg_web_2022/conjunto_de_datos/conjunto_de_datos_tmodulo_endiseg_web_2022.csv", sep = "")

#Population per state, 2020
#Note: Data is the same for both years, so it is sufficient to utilize this file
path_population <- paste(path_endiseg2021, "\\Poblacion.csv", sep = "")

#Other generalizations (the last "NE" stands for not specified)
shortStateNames <- c("AGU","BCN","BCS","CAM","COA","COL","CHP","CHH","CMX","DUR","GUA","GUE","HID","JAL","MEX","MIC","MOR","NAY"
                ,"NLE","OAX","PUE","QUE","ROO","SLP","SIN","SON","TAB","TAM", "TLA","VER","YUC","ZAC","NE")



#2.) Data for: Percentage of the population that responded to ENDISEG
  #Desired variables: 
  #State: ENT, TMODULO


#Note: The order here is the same as the resuting one
population_2020 <- as.data.frame(read.csv(path_population))

#Population 
population_2020$Pob2020 <- str_replace(population_2020$Pob2020, ",","")
population_2020$Pob2020 <- str_replace(population_2020$Pob2020, ",","")
population_2020$Pob2020 <- as.numeric(as.character(population_2020$Pob2020))


#Data for ENDISEG 2021
tmodulo_2021 <- as.data.frame(read.csv(path_tmodulo_2021))
states_2021 <- tmodulo_2021 %>% select(FOLIO, ENT)
auxState_2021 <- states_2021['ENT']

#Changes states numeric values for their short names
for(i in 1:(length(shortStateNames)-1))
  auxState_2021[auxState_2021 == i] = shortStateNames[i]
states_2021 <- states_2021%>% mutate(ENT = auxState_2021)

#changes the states_2021 data frame to include the ocurrences of each state in
#the ENDISEG 2021 
states_2021 <- count(states_2021$ENT)
states_2021 <- dplyr::rename(states_2021, count_2021 = freq)


#Data for ENDISEG WEB 2022
tmodulo_2022 <- as.data.frame(read.csv(path_tmodulo_2022))
states_2022 <- tmodulo_2022 %>% select(NIP, ENT)
auxState_2022 <- states_2022['ENT']

#Changes states numeric values for their short names
for(i in 1:(length(shortStateNames)-1))
  auxState_2022[auxState_2022 == i] = shortStateNames[i]

auxState_2022[auxState_2022 == 0] = shortStateNames[length(shortStateNames)]
auxState_2022[auxState_2022 == "b"] = shortStateNames[length(shortStateNames)]
auxState_2022[is.na(auxState_2022)] = shortStateNames[length(shortStateNames)]

states_2022 <- states_2022 %>% mutate(ENT = auxState_2022)
states_2022 <- count(states_2022$ENT)
states_2022 <- dplyr::rename(states_2022, count_2022 = freq)


#Creates data frame for ocurrences in both surveys
state_occurrences <- merge(states_2021,states_2022, by = "ENT")

#Adds population in 2020
state_occurrences <- state_occurrences %>% mutate(Pop2020 = population_2020$Pob2020)

#Creates percentages for 2021 and 2022
state_occurrences <- state_occurrences %>% mutate(Perc_2021 = 100*count_2021/Pop2020, Perc_2022 = 100*count_2022/Pop2020)

file_state_occurrences <- paste(dataToBeAnalized,"/state_occurrences.csv", sep = "")
write.csv(state_occurrences, file_state_occurrences, row.names = FALSE)

paste("Done for 2.)")

