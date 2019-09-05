###################!!!THIS SCRIPT IS UNFINISHED!!!!##################
############This is an R Script to analyze a gene dataset with ggbio in R############

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ggbio", version = "3.8", dependencies=TRUE)


#chr 1 is automatically drawn by default (subchr="chr1")
library(ggbio)
p.ideo <- Ideogram(genome = "hg19")
p.ideo
#Highlights a region on "chr2"
library(GenomicRanges)
p.ideo + xlim(GRanges("chr2", IRanges(1e7, 1e8+10000000)))

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("Mus.musculus", version = "3.8")

library(ggbio)
library(Mus.musculus)
class(Mus.musculus)
data(genesymbol, package="biovizBase")
wh<-genesymbol[c("BRCA1", "NBR1")]
wh<-range(wh, ignore.strand=TRUE)

which <- GRanges("chr4", IRanges(1, 5000))

p.txdb<-autoplot(Homo.sapiens, which=which)
p.txdb

autoplot()

autoplot(Mus.musculus, which = wh, label.color = "black", color = "brown",
         fill = "brown")

