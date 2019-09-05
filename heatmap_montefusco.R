###This is a script to make a heatmap using R################
###Vincent Perez
###03/15/2019
###===========================================================================================================

setwd("C:/Users/vincent/Google Drive/blacklab/computer work/Manuscripts/montefusco_manuscript/r_workspace")
read.csv("oleic_acid_heatmap.csv")        #Check your file
oa<-read.csv("oleic_acid_heatmap.csv")    #Objectify the file
row.names(oa) <- oa$phospholipid_species  #Start to build a name object

###alternatively, this is useful too
row1<-oa[,1]
row.names(oa)<-make.names(row1, unique=TRUE)

###the fix() function is great for quickly making edits to a data frame
fix(oa)

###Lets build the Matrix, Neo
oa <- oa[,2:6]
oa_matrix <- data.matrix(oa)		          #transforms data into a matrix

pdf("heatmap.pdf")                        #Finally, let there be heatmapt
oa_heatmap <- heatmap(oa_matrix, Rowv=NA, Colv=NA, col = heat.colors(256), scale="column", margins=c(5,10))
dev.off()                                 #Its not pretty but you get the idea

###alternatively, this will create a nicer heatmape with ggplot
###We're changing the matrix to a logarithmic scale for easier viewing. You don't have to do this.

library("gplots")
log_smpl<-log(oa_matrix)

###remove the cells filled with '-lnf' and replce with '0'
fix(log_smpl)
smpl_heatmap<-heatmap.2(log_smpl, col=heat.colors(180),
                        margins=c(8,10))
###done!
###===========================================================================================================
###the below scripts creates 4 separate heatmaps in the directory

bitmap(file="heatmap_BW_T.tiff", height=3,
       width=9, units="in", res=600)
smpl_heatmap<-heatmap.2(log_smpl, Rowv=NA, Colv=NA,
                        col=gray(0:100/100), scale_x_continuous(breaks=NA),
                        margins=c(5,10))
dev.off()


bitmap(file="heatmap_BW.tiff", height=4,
       width=4, units="in", res=600)
smpl_heatmap<-heatmap.2(log_smpl, Rowv=NA, Colv=NA,
                        col=gray(0:100/100), scale_x_continuous(breaks=NA),
                        margins=c(5,10), tracecol=NA)
dev.off()

bitmap(file="heatmap_color_T.tiff", height=3,
       width=9, units="in", res=600)
smpl_heatmap<-heatmap.2(log_smpl, Rowv=NA, Colv=NA,
                        col=colorRampPalette(c('blue','yellow','red'))(100),
                        scale_x_continuous(breaks=NA), margins=c(5,10))
dev.off()

bitmap(file="heatmap_color.tiff", height=4,
       width=4, units="in", res=600)
smpl_heatmap<-heatmap.2(log_smpl, Rowv=NA, Colv=NA,
                        col=colorRampPalette(c('blue','yellow','red'))(100),
                        scale_x_continuous(breaks=NA), margins=c(5,10),
                        tracecol=NA)
dev.off()




