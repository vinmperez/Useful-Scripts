################This is an R Script to create a clusterplot using Metabolic Models R##########################
#Vincent Perez
#03/12/2019
#===================================================================================================#
### (1) Move in to the correct directory and set your working directory

library(ggplot2)
library(grid)
setwd("C:/Users/vincent/Google Drive/helikarlab/Modeling Project/Figures and Presentations/clusterPlot/")

data=read.csv("Gex Clusterplot Analysis Simpler.csv", header=TRUE)
head(data)
tail(data)
names<-as.vector(data[,1])
valuesA<-as.vector(data[,2])
valuesB<-as.vector(data[,3])
var.names<-names
var.order<-seq(nrow(data))
values.a<-valuesA
values.b<-valuesB
group.names <- c("Wildtype", "Fatp2 Remi Gex")

###(2) Create df1: a plotting data frame in the format required for ggplot2

df2.a <- data.frame(matrix(c(rep(group.names[1], nrow(data)), var.names), nrow = nrow(data), ncol = 2), 
                    var.order = var.order, value = values.a)
df2.b <- data.frame(matrix(c(rep(group.names[2], nrow(data)), var.names), nrow = nrow(data), ncol = 2), 
                    var.order = var.order, value = values.b)
df2 <- rbind(df2.a, df2.b) 
colnames(df2) <- c("group", "Metabolic.Biosystem", "variable.order", "Fluxsum")
head(df2)
tail((df2))

### (3) Lets make us a plot.

myang1<-seq(90, 0, length.out=nrow(data)/4)
myang2<-seq(0, -90, length.out=nrow(data)/4)
myang3<-seq(90, 0, length.out=nrow(data)/4)
myang4<-seq(0, -90, length.out=nrow(data)/4)
myang5<-c(myang1, myang2, myang3, myang4)


g<-ggplot(df2, aes(y = Fluxsum, x = reorder(Metabolic.Biosystem, variable.order), 
                group = group, colour = group)) + coord_polar()  +geom_path(lineend= "butt", size=0.25) +
                theme(panel.background = element_rect(fill = "white",colour = "white",size = 2.5, linetype = "solid"),
                  panel.grid.major = element_line(size = 0.1, linetype = 'solid', colour = "grey"), 
                  panel.grid.minor = element_line(size = 0.1, linetype = 'solid', colour = "grey"),
                  text = element_text(size=8),
                  axis.text.x = element_text(angle=myang5),
                  axis.text.y = element_blank(),
                  axis.ticks = element_blank(),
                  plot.margin = unit(c(2, 0,-1, 0), "cm"),
                  legend.justification='top') +
                labs(x=NULL, y=NULL)
g

###Turn off clipping and export the image

png(file="Remi_GEX_ChowD Simple.png",width=3300 ,height=2000,res=300)
gt <- ggplot_gtable(ggplot_build(g))
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