################This is an R Script to create a alluvial plot using Metabolic Models R##########################
#Vincent Perez
#08/21/2019
#===================================================================================================#
### Install the libraray alluvial if necessary

#install.packages("alluvial")
#library(alluvial)

###You can run the below 8 lines without changing directories just to see how the code works using R's built in titanic dataset 
#tit <- as.data.frame(Titanic, stringsAsFactors = FALSE)
#head(tit)
#alluvial(tit[,1:4], freq=tit$Freq,
#         col = ifelse(tit$Survived == "Yes", "orange", "grey"),
#         border = ifelse(tit$Survived == "Yes", "orange", "grey"),
#         hide = tit$Freq == 0,
#         cex = 0.7
#)

#===================================================================================================#

setwd("C:/Users/vincent/Desktop/")
library(alluvial)
data=as.data.frame(read.csv("./data_temp.csv", header = TRUE))
head(data)
tail(data)
alluvial(data[,1:6], freq=data$Flux,
         col = ifelse(data$Genotype == "WT", "white", "blue"),
         border = ifelse(data$Genotype == "Chow", "white", "darkgrey"),
         hide = data$Flux == 0,
         cex = 0.75
)
