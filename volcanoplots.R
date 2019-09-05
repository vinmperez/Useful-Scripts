################This is an R Script to make Volcano Plots from RNA seq data##########################
#Vincent Perez
#02/07/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory

library("ggplot2")
library("gridExtra")
library("plotly")
library('readr')

setwd("C:/Users/vincent/Desktop/")
data<-read.csv("Exp 135 136 RNA-seq.csv", header=TRUE)

KOKvsWTK<- data[c("GeneName", "log2FoldChange.WTKvsKOK.", "padj.WTKvsKOK.")]

###Lets add a column to signify significance

KOKvsWTK["group"]<-"Neither"

KOKvsWTK[which(KOKvsWTK['padj.WTKvsKOK.']< 0.05 
                   & abs(KOKvsWTK['log2FoldChange.WTKvsKOK.']) < 1.0),"group"] <- "P-value=< 0.05"

KOKvsWTK[which(KOKvsWTK['padj.WTKvsKOK.'] > 0.05 
                   & abs(KOKvsWTK['log2FoldChange.WTKvsKOK.']) > 1.0),"group"] <- "|FC|>=1.0"

KOKvsWTK[which(KOKvsWTK['padj.WTKvsKOK.'] < 0.05 
                   & abs(KOKvsWTK['log2FoldChange.WTKvsKOK.']) > 1.5 ),"group"] <- "P-value=< 0.05 & |FC|>=1.0"

###Lets label the top peaks

top_peaks <- KOKvsWTK[with(KOKvsWTK, order(log2FoldChange.WTKvsKOK., padj.WTKvsKOK.)),][1:5,]

top_peaks <- rbind(top_peaks, KOKvsWTK[with(KOKvsWTK, order(-log2FoldChange.WTKvsKOK., padj.WTKvsKOK.)),][1:5,])

###Add some gene labels to the plot

m<- KOKvsWTK[with(KOKvsWTK, order(log2FoldChange.WTKvsKOK., padj.WTKvsKOK.)),][1,]

a <- list(
     x = m[["log2FoldChange.WTKvsKOK."]],
     y = -log10(m[["padj.WTKvsKOK."]]),
     text = m[["GeneName"]],
     xref = "x",
     yref = "y",
     showarrow = TRUE,
     arrowhead = 7,
     ax = 20,
     ay = -40
   )

a <- list()
for (i in seq_len(nrow(top_peaks))) {
  m <- top_peaks[i, ]
  a[[i]] <- list(
    x = m[["log2FoldChange.WTKvsKOK."]],
    y = -log10(m[["padj.WTKvsKOK."]]),
    text = m[["GeneName"]],
    xref = "x",
    yref = "y",
    showarrow = TRUE,
    arrowhead = 0.5,
    ax = 20,
    ay = -40
  )
}

###Lets plot this biatch

p <- plot_ly(data = KOKvsWTK, x = KOKvsWTK$log2FoldChange.WTKvsKOK., y = -log10(KOKvsWTK$padj.WTKvsKOK.), text = m$GeneName, 
             mode = "markers", color = KOKvsWTK$group) %>% 
  layout(title ="Volcano Plot of FATP2-/- KD vs Control KD DEGs") %>%
  layout(annotations = FALSE)
p

htmlwidgets::saveWidget(p, file = "test.html")