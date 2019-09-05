################This is an R Script to draw venn diagrams with VennDiagram package in R##########################
#Vincent Perez
#01/28/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory, load library, and import data

library(VennDiagram)
setwd("C:/Users/vincent/Google Drive/helikarlab/Modeling Project/Figures/Model Genes vs DEGs/")

###This draws a circle with a number in it, the number being the area
draw.single.venn(area=2235, category="All Model Genes")

###Lets add some color
grid.newpage()
draw.single.venn(area=2235, category="All Model Genes", lty="blank", fill="cornflower blue", 
                 alpha=0.5)

###Lets add another two circles
grid.newpage()
venn.diagram<-draw.pairwise.venn(2148,260,87, category=c("All Model Genes", "DEGs of Transcriptome
                                                          "), 
                   lty=rep("blank",2), 
                   fill=c("blue", "red"),
                   alpha=rep(0.5, 2), 
                   cat.pos=c(0,0), 
                   cat.dist=rep(0.025, 2), 
                   scaled=TRUE)

###Lets add a third circle
grid.newpage()
draw.triple.venn(area1=2148,area2=260,area3=41092, n12=87, n23=260, n13=2148, n123=87,
                   category=c("All Model Genes", "DEGs of Transcriptome", "Whole Transcriptome"), 
                   lty="blank", 
                   fill=c("red", "blue", "mediumorchid"),
                   scaled=TRUE)