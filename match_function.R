################This is an R Script to Match and Rearrange Columns based on Match##########################
#Vincent Perez
#03/17/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory

setwd("C:/Users/vincent/Desktop/RNA-seq 135 136 Workspace/edgeR_results files/")
Pairwise<-read.csv("edgeR_results All Pairwise KO Comparisons.csv")
Pairwise
P1<-Pairwise[,1:6]
P2<-Pairwise[,7:12]
P12<-merge(P1, P2)
P12

merge(authors, books, by=1:2)

#===================================================================================================#
###My script above was based off of this below script. Beyond here are notes###

authors <- data.frame(
  FirstName=c("Lorne", "Loren", "Robin",
              "Robin", "Billy"),
  LastName=c("Green", "Jaye", "Green",
             "Howe", "Jaye"),
  Age=c(82, 40, 45, 2, 40),
  Income=c(1200000, 40000, 25000, 0, 27500),
  Home=c("California", "Washington", "Washington",
         "Alberta", "Washington"))

books <- data.frame(
  AuthorFirstName=c("Lorne", "Loren", "Loren",
                    "Loren", "Robin", "Rich"),
  AuthorLastName=c("Green", "Jaye", "Jaye", "Jaye",
                   "Green", "Calaway"),
  Book=c("Bonanza", "Midwifery", "Gardening",
         "Perennials", "Who_dun_it?", "Support"))

merge(authors, books, by=1:2)