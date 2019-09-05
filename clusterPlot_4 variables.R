################This is an R Script to create a clusterplot using Metabolic Models R##########################
#Vincent Perez
#03/12/2019
#===================================================================================================#
### (1) Move in to the correct directory and set your working directory

library(ggplot2)
library(grid)
setwd("C:/Users/vincent/Google Drive/helikarlab/Modeling Project/Figures and Presentations/clusterPlot/")

data4=read.csv("slc27a2Rxns_con_0_1000_Lipid Metabolism.csv", header=TRUE)
head(data4)
tail(data4)
names2<-as.vector(data4[,1])
valuesA<-as.vector(data4[,2])
valuesB<-as.vector(data4[,3])
valuesC<-as.vector(data4[,4])
valuesD<-as.vector(data4[,5])
var.names<-names2
var.order<-seq(1:44)
values.a<-valuesA
values.b<-valuesB
values.c<-valuesC
values.d<-valuesD
group.names <- c("Fatp2 Rxns Constricted to 0", "Fatp2 Rxns Constricted to |10|",
                 "Fatp2 Rxns Constricted to |500|", "Fatp2 Rxns Constricted to |1000|")

###(2) Create df1: a plotting data frame in the format required for ggplot2

df4.a <- data.frame(matrix(c(rep(group.names[1], 44), var.names), nrow = 44, ncol = 2), 
                    var.order = var.order, value = values.a)
head(df4.a)
df4.b <- data.frame(matrix(c(rep(group.names[2], 44), var.names), nrow = 44, ncol = 2), 
                    var.order = var.order, value = values.b)
head(df4.b)
df4.c <- data.frame(matrix(c(rep(group.names[3], 44), var.names), nrow = 44, ncol = 2), 
                    var.order = var.order, value = values.c)
head(df4.c)
df4.d <- data.frame(matrix(c(rep(group.names[4], 44), var.names), nrow = 44, ncol = 2), 
                    var.order = var.order, value = values.d)
head(df4.d)
df4 <- rbind(df4.a, df4.b, df4.c, df4.d) 
colnames(df4) <- c("group", "Metabolic.Biosystem", "variable.order", "Sum.of.Carbon.Flux")
head(df4)

### (3) Lets make us a plot.

myang1<-seq(90, 0, length.out=11)
myang2<-seq(0, -90, length.out=11)
myang3<-seq(90, 0, length.out=11)
myang4<-seq(0, -90, length.out=11)
myang5<-c(myang1, myang2, myang3, myang4)

grid.newpage()
g4<-ggplot(df4, aes(y = Sum.of.Carbon.Flux, x = reorder(Metabolic.Biosystem, variable.order), 
                group = group, colour = group)) + coord_polar()  +geom_path(lineend= "butt", size=0.25) +
                theme(panel.background = element_rect(fill = "white",colour = "white",size = 1.0, linetype = "solid"),
                  panel.grid.major = element_line(size = 0.1, linetype = 'solid', colour = "grey"), 
                  panel.grid.minor = element_line(size = 0.1, linetype = 'solid', colour = "grey"),
                  text = element_text(size=6),
                  axis.text.x = element_text(angle=myang5),
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(),
                  plot.margin = unit(c(2, 2,2, 2), "cm"),
                  legend.justification='top') +
                labs(x=NULL, y=NULL)
g4

###Turn off clipping and export the image

png(file="Fatp2 Rxns Con 0 to 1000 - Lipid Metabolism.png",width=3300 ,height=2000,res=300)
gt <- ggplot_gtable(ggplot_build(g4))
gt$layout$clip[gt$layout$name == "panel"] <- "off"
grid.draw(gt)
dev.off()
dev.off()

#===================================================================================================#
###Done! Everything after this are my own personal notes.###
###This is an alternative that I can't quite get to work, but if you want to fiddle with the code,
###you may prefer this.

m2 <- matrix(c(values.a, values.b), nrow = 2, ncol = 71, byrow = TRUE)
group.names <- c(group.names[1:2])
df2 <- data.frame(group = group.names, m2)
colnames(df2)[2:71] <- var.names
print(df2)

source("http://pcwww.liv.ac.uk/~william/Geodemographic%20Classifiability/func%20CreateRadialPlot.r")
CreateRadialPlot(df2, plot.extent.x = 1.5, centre.y=-30000, grid.max=10000)

CreateRadialPlot(df2, plot.extent.x = 1.5, grid.min = 100, centre.y = -5000, grid.max=9000, 
                 label.centre.y = TRUE, label.gridline.min = FALSE)