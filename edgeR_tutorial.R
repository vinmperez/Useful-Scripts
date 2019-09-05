################This is an R Script to perform Differential Expression Analysis in R##########################
#Vincent Perez
#01/23/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory, and open up this neat little user guide >.>

library(edgeR)
edgeRUsersGuide()
library(readr)
setwd("Z:/RNA Seq Data/Exp 134/C202SC18050484_Mus_musculus_TR_result/C202SC18050484_Mus_musculus_results/0.SuppFiles/")

#===================================================================================================#
###This is a continuation of the "tximport_tutorial.R" file
###Make the counts data.frame we'll be using

counts = read.csv("counts.csv", header=TRUE)
group<-factor(c(1,1,1,2,2,2,2,3,3,3,3,4,4,4,4))
dgList<-DGEList(counts=counts[,2:16], genes=counts$GeneName, group=group)
dgList$samples
head(dgList$counts)
head(dgList$genes) 

#===================================================================================================#
###FILTERING
###Here I'm filtering out transcripts based on their CPM (Counts per Million). I use CPM to account for
###library size differences. I also am selecting for transcripts that are found in all samples, rather
###thank transcripts found in, say, 3/8 of the samples. 

countsPerMillion <- cpm(dgList)
summary(countsPerMillion)
countCheck <- countsPerMillion > 1
head(countCheck)
keep <- which(rowSums(countCheck) >= 8)
dgList <- dgList[keep,]
summary(cpm(dgList)) 

#===================================================================================================#
###NORMALIZATION
###"calcNormFactors" function normalizes for RNA composition by finding a set of scaling factors 
###for the library sizes that minimize the log-fold changes between the samples for most genes
###Trimmed mean of M-values (TMM) is the default method for calcNormFactors, and it is the recommended
###library scaling method for most RNA-seq data assumming that more than half genes are not DEGs.

dgList <- calcNormFactors(dgList, method="TMM")
dgList$samples
points<-c(0,1,3,4)
colors<-rep(c('blue', 'red'),4)
plotMDS(dgList, col=colors[group], pch=points[group], cex = 1.0)
legend('topleft', legend=c('Female WT','Female Fatp2-/-', 'Male WT','Male Fatp2-/-'), pch=points, col=colors,ncol=1)

#===================================================================================================#
###Lets setup the model, we're using GLM for MULTIPLE FACTORS, if single factor remove GLM in lines
###By default, when you add the "designMat" to the estimateDisp() function it prompts the use of 
###GLM dispersion estimate

designMat <- model.matrix(~group)
designMat
y<-estimateGLMCommonDisp(dgList, designMat)
y<-estimateGLMTagwiseDisp(y)
y$common.dispersion
plotBCV(y)

#===================================================================================================#
###Perform QL or F-test. F-test is robust and useful when replicate numbers are small. QL test is
###These tests are only useful in experiments with MULTIPLE FACTORS! "coef" tells the model
###what to compare. "coef=2" will be 2vs1, whereas, "contrast=c(0,-1,1) would ve 3 vs 2. 
###If you're looking for genes that are different between any of the 4 groups it'd be "coef=3:2"

fit<-glmQLFit(y, designMat, robust=TRUE)
plotQLDisp(fit)
qlf.2468vs1<-glmQLFTest(fit, coef=c(2,4,6,8))
topTags(qlf.2468vs1)
edgeR_results <- topTags(qlf.2468vs1, n=Inf)
deGenes <- decideTestsDGE(qlf.2468vs1, p=0.05)
deGenes <- rownames(qlf.2468vs1)[as.logical(deGenes)]
plotSmear(qlf.2468vs1, de.tags=deGenes)
abline(h=c(-1, 1), col=2)
write.csv(edgeR_results, "./edgeR_results All KO.csv")

#===================================================================================================#
###Everything after here is notes....
###qCLM are for experiments with single factors, this is performed by default using
###the following: estimateDisp(), estimateCommonDisp(), and estimateTagwiseDisp().  
###note that you must estimateCommonDisp before estimateTagwiseDisp()
###Perform exact test to determine DE genes. Exact test is strongly paralleled with Fisher's Exact Test.
###This test is only useful in experiments with SINGLE FACTOR!!! 

et<-exactTest(y)
topTags(et)





