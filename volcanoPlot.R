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

KOC_kvsWTC_k<- data[c("GeneName", "log2FoldChange.WTC_kvsKOC_k.", "padj.WTC_kvsKOC_k.")]

###Lets add a column to signify significance

KOC_kvsWTC_k["group"]<-"Not Significant"

KOC_kvsWTC_k[which(KOC_kvsWTC_k['padj.WTC_kvsKOC_k.']< 0.05 
                   & abs(KOC_kvsWTC_k['log2FoldChange.WTC_kvsKOC_k.']) < 1.0),"group"] <- "Significant"

KOC_kvsWTC_k[which(KOC_kvsWTC_k['padj.WTC_kvsKOC_k.'] > 0.05 
                   & abs(KOC_kvsWTC_k['log2FoldChange.WTC_kvsKOC_k.']) > 1.0),"group"] <- "FoldChange"

KOC_kvsWTC_k[which(KOC_kvsWTC_k['padj.WTC_kvsKOC_k.'] < 0.05 
                   & abs(KOC_kvsWTC_k['log2FoldChange.WTC_kvsKOC_k.']) > 1.5 ),"group"] <- "Significant&FoldChange"

###Lets label the top peaks

top_peaks <- KOC_kvsWTC_k[with(KOC_kvsWTC_k, order(log2FoldChange.WTC_kvsKOC_k., padj.WTC_kvsKOC_k.)),][1:5,]

top_peaks <- rbind(top_peaks, KOC_kvsWTC_k[with(KOC_kvsWTC_k, order(-log2FoldChange.WTC_kvsKOC_k., padj.WTC_kvsKOC_k.)),][1:5,])

###Add some gene labels to the plot

m<- KOC_kvsWTC_k[with(KOC_kvsWTC_k, order(log2FoldChange.WTC_kvsKOC_k., padj.WTC_kvsKOC_k.)),][1,]

a <- list(
     x = m[["log2FoldChange.WTC_kvsKOC_k."]],
     y = -log10(m[["padj.WTC_kvsKOC_k."]]),
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
    x = m[["log2FoldChange.WTC_kvsKOC_k."]],
    y = -log10(m[["padj.WTC_kvsKOC_k."]]),
    text = m[["GeneName"]],
    xref = "x",
    yref = "y",
    showarrow = TRUE,
    arrowhead = 0.5,
    ax = 20,
    ay = -40
  )
}

p <- plot_ly(data = KOC_kvsWTC_k, x = log2FoldChange.WTC_kvsKOC_k., y = -log10(padj.WTC_kvsKOC_k.), text = GeneName, 
             mode = "markers", color = group) %>% 
  layout(title ="Volcano Plot") %>%
  layout(annotations = a)
p
