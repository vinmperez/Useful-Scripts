txi = tximport(files, type = "salmon",
               txIn = TRUE, txOut = FALSE, countsFromAbundance="scaledTPM", tx2gene = tx2gene, varReduce = FALSE,
               dropInfReps = FALSE, ignoreTxVersion = FALSE, geneIdCol = tx2gene[,2], txIdCol = tx2gene[,1],
               abundanceCol = "TPM", countsCol = "counts", lengthCol = "length", importer = NULL)

