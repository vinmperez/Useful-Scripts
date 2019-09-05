##-------------------------------------
library(tximport)
library(readr)

dir <- "Z:/RNA Seq Data/Exp 134/ quants"

samples <- read.csv(file.path ("samples_info.txt"), header = TRUE)
samples

files <- file.path(dir, samples$Salmon_out, "quant.sf")
names(files) <- paste0(samples$Salmon_out)
all(file.exists(files))

library(biomaRt) #Get annotation files.
listMarts()
ensMart<-useMart("ensembl")
listDatasets(ensMart)
ensembl_hs_mart <- useMart(biomart="ensembl", dataset="mmusculus_gene_ensembl")

listAttributes(ensembl_hs_mart)[1:100,]

xx = getBM(attributes = c("ensembl_gene_id", "ensembl_transcript_id", "ensembl_transcript_id_version" , "entrezgene", 
                          "start_position", "end_position", "transcript_start", "transcript_end"),
           mart       = ensembl_hs_mart)
write.csv(xx, "xx.csv")

annotation = read.csv('./xx.csv', h=T) #Importing our annotation file
  # tx ID, then gene ID
tx2gene <- annotation[, c(3:1)]  # tx ID, then gene ID (we will use transcript id, gene, id, et cetera)

#generating counts

library(tximport)




txi <- tximport(files, type = "salmon", countsFromAbundance ="no",tx2gene = tx2gene)
names(txi)
head(txi$counts)
counts = txi$counts
write.csv(counts, "./counts.csv")

gene_length = txi$length