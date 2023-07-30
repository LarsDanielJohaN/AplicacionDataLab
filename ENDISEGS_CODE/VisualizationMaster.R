#Created by: Lars Daniel Johansson Niño
#Last edited date: 12/26/22
#Purpose: Visualize data from ENDISEG 2021 and ENDISEG WEB 2022
#Note: The code in this file requires for the latest version of R as of 28/12/22 to be installed, aswell as the latest version of its packages

paste("Hello visualization!")
library(ggplot2)


#The code is divided into the following sections:
    #1.) Generalizations
    #2.) Visualizations for: Percentage of the population that responded to ENDISEG

#LGBT activity on facebook


#1.) Generalizations

path_data_to_be_analized <- "/Users/larsdanieljohanssonnino/Desktop/ResearchCode/ENDISEG/DataToBeAnalized"
numeric_value_state_region <- 01:32;

#2.) Visualizations for: Percentage of the population that responded to ENDISEG

path_state_ocurrences <- paste(path_data_to_be_analized, "/state_occurrences.csv", sep = "") 
state_occurrences <- as.data.frame(read.csv(path_state_ocurrences))

#Visualizations for ENDISEG 2021


#Percentage of the population that responded
percentage_2021_barchart <- ggplot(state_occurrences, aes(x = ENT, y = Perc_2021, fill = ENT )) + geom_bar(stat = "identity")+
                       labs(x = "State", y = "Percentage", title = "Responses to ENDISEG 2021 as percentage of state population")

#Count of responses  
count_2021_barchart <- ggplot(state_occurrences, aes(x = ENT, y = count_2021, fill = ENT )) + geom_bar(stat = "identity")+
  labs(x = "State", y = "Responses", title = "Number of responses to ENDISEG 2021 per state")

#Map visualization
  #Preeliminary data editing (so it works with the mxmaps package)
mapVis_data_Perc2021 <- data.frame(region = numeric_value_state_region, value = state_occurrences$Perc_2021)
percentage_2021_map <- mxstate_choropleth(mapVis_data_Perc2021, title = "Population percentage which responded to ENDISEG 2021")



#Visualizations for ENDISEG WEB 2022

#Percentage of the population that responded
percentage_2022_barchart <- ggplot(state_occurrences, aes(x = ENT, y = Perc_2022, fill = ENT )) + geom_bar(stat = "identity")+
  labs(x = "State", y = "Percentage", title = "Responses to ENDISEG WEB 2022 as percentage of state population")

#Count of responses  
count_2022_barchart <- ggplot(state_occurrences, aes(x = ENT, y = count_2022, fill = ENT )) + geom_bar(stat = "identity")+
  labs(x = "State", y = "Responses", title = "Number of responses to ENDISEG WEB 2022 per state")

#Map visualization
#Preeliminary data editing (so it works with the mxmaps package)
mapVis_data_Perc2022 <- data.frame(region = numeric_value_state_region, value = state_occurrences$Perc_2022)
