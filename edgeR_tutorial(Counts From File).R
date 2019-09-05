################This is an R Script to perform Differential Expression Analysis in R##########################
#Vincent Perez
#01/23/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory, and open up this neat little user guide >.>

edgeRUsersGuide()
library(edgeR)
library(readr)
setwd("C:/Users/vincent/Desktop/RNA-seq 135 136 Workspace/")

#===================================================================================================#
###This is a continuation of the "tximport_tutorial.R" file
###Make the counts data.frame we'll be using

counts = read.csv("counts_kokvswtk.csv", header=TRUE)
group<-factor(c(2,2,2,2,1,1,1,1))
dgList<-DGEList(counts=counts[,2:9], genes=counts$GeneName, group=group)
dgList$samples
head(dgList$counts)
head(dgList$genes) 

#===================================================================================================#
###Filtering 

countsPerMillion <- cpm(dgList)
summary(countsPerMillion)
countCheck <- countsPerMillion > 1
head(countCheck)
keep <- which(rowSums(countCheck) >= 4)
dgList <- dgList[keep,]
summary(cpm(dgList)) 

#===================================================================================================#
###"calcNormFactors" function normalizes for RNA composition by finding a set of scaling factors 
###for the library sizes that minimize the log-fold changes between the samples for most genes
###Trimmed mean of M-values (TMM) is the default method for calcNormFactors, and it is the recommended
###library scaling method for most RNA-seq data assumming that more than half genes are not DEGs

dgList <- calcNormFactors(dgList, method="TMM")
dgList$samples
plotMDS(dgList)

#===================================================================================================#
###Lets setup the model, we're using GLM for MULTIPLE FACTORS, if single factor remove GLM in lines
###By default, when you add the "designMat" to the estimateDisp() function it prompts the use of 
###GLM dispersion estimate

designMat <- model.matrix(~group)
designMat
y<-estimateGLMCommonDisp(dgList, designMat)
y<-estimateGLMTagwiseDisp(y)

#===================================================================================================#
###Perform QL or F-test. F-test is robust and useful when replicate numbers are small. QL test is
###These tests are only useful in experiments with MULTIPLE FACTORS!!! "coef" tells the model
###what to compare. "coef=2" will be 2vs1, whereas, "contrast=c(0,-1,1) would ve 3 vs 2. 
###If you're looking for genes that are different between any of the 4 groups it'd be "coef=3:2"

fit<-glmQLFit(y, designMat)
qlf.2vs1<-glmQLFTest(fit, coef=2)
topTags(qlf.2vs1)
edgeR_results <- topTags(qlf.2vs1, n=Inf)
deGenes <- decideTestsDGE(qlf.2vs1, p=0.05)
deGenes <- rownames(qlf.2vs1)[as.logical(deGenes)]
plotSmear(qlf.2vs1, de.tags=deGenes)
abline(h=c(-1, 1), col=2)
write.csv(edgeR_results, "edgeR_results (kokvswtk).csv")

#===================================================================================================#
###Everything after here is notes....
###qCLM are for experiments with single factors, this is performed by default using
###the following: estimateDisp(), estimateCommonDisp(), and estimateTagwiseDisp().  
###note that you must estimateCommonDisp before estimateTagwiseDisp()
###Perform exact test to determine DE genes. Exact test is strongly paralleled with Fisher's Exact Test.
###This test is only useful in experiments with SINGLE FACTOR!!! 

et<-exactTest(y)
topTags(et)





