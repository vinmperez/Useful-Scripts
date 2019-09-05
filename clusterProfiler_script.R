#########################This is an R Script to analyze a gene dataset using clusterProfiler in R##########################
#Vincent Perez
#12/04/2018
#===================================================================================================#
###install clusterProfiler 

if (!requireNamespace("BiocManager", quietly = TRUE)) 
install.packages("BiocManager")
BiocManager::install("clusterProfiler", version = "3.8") 
###Here we can read the documentation of clusterProfiler in your  browser
browseVignettes('clusterProfiler') 

#===================================================================================================#
###Load your libraries. You'll need org.Mm.eg.db for mice or org.Hs.eg.db for human.

library(clusterProfiler)
library(org.Mm.eg.db)
keytypes(org.Mm.eg.db)
###Change your working directory to any desired. Then load a vector genelist like sow.
setwd("C:/Users/vincent/Google Drive/helikarlab/Modeling Project/")
genes<-c("Gm15441",	"4930534D22Rik",	"-//-",	"1700080G11Rik",	"-//-",	"Gm27325",	"Gm16551",	"Tram1",	"Nrp2",	"Rufy4",	"Mogat1",	"Ugt1a9",	"Pigr",	"Ctse",	"Lad1",	"Ephx1",	"Tlr5",	"Esrrg",	"Vnn1",	"Slc35f1",	"Gstt2",	"Tmem19",	"-//-",	"Sdr9c7",	"Slc39a5",	"Gal3st1",	"Ugp2",	"Rtn4",	"Iba57",	"Dhrs7b",	"Aldh3a2",	"Slc16a11",	"Slc16a13",	"Tmem98",	"Pctp",	"Abcc3",	"Acsf2",	"Krt23",	"Adam11",	"Limd2",	"Map2k6",	"Acox1",	"Ten1",	"Rnf144a",	"Arl4a",	"Egln3",	"Acot1",	"Acot3",	"Acot6",	"Entpd5",	"Ppp4r4",	"Serpina12",	"Serpina3m",	"Ankrd9",	"Akr1c6",	"Ero1lb",	"Hist1h4h",	"Slc17a2",	"Slc17a1",	"Eci2",	"Ntrk2",	"Fbp2",	"Irx1",	"Abhd6",	"Lrtm1",	"Hacl1",	"Rnase4",	"Dhrs4",	"Fitm1",	"Chrna2",	"Hr",	"Slc25a30",	"Vwa8",	"C9",	"Sdc2",	"Oplah",	"Slc52a2",	"Pla2g6",	"Pmm1",	"5031439G07Rik",	"Fam19a5",	"Chkb",	"Fkbp11",	"Smagp",	"Rogdi",	"Ehhadh",	"Tnk2",	"-//-",	"Pdia5",	"Sema5b",	"Alcam",	"Cpox",	"Mrap",	"Eci1",	"Fam195a",	"Decr2",	"Cdkn1a",	"Cyp4f17",	"Angptl4",	"Slc22a7",	"Plin5",	"Ptprs",	"Abcg8",	"Mkx",	"Cdo1",	"Hsd17b4",	"Grpel2",	"Gm4952",	"Gna14",	"Cyp2c29",	"Cyp2c70",	"Scd1",	"Sh3pxd2a",	"Acsl5",	"Psd4",	"BC029214",	"Crat",	"Uck1",	"Fam102a",	"Cerkl",	"Pex16",	"Them7",	"Disp2",	"Exd1",	"Haus2",	"Catsper2",	"Pdia3",	"Spg11",	"Sord",	"Slc27a2",	"Pxmp4",	"Acss2",	"Edem2",	"Snhg11",	"Fitm2",	"Acot8",	"Neurl2",	"Pltp",	"Atp9a",	"Sall4",	"Rtfdc1",	"Nceh1",	"Pgrmc2",	"Rarres1",	"Ntrk1",	"Il6ra",	"Gstm4",	"Abcd3",	"Tifa",	"Cyp2u1",	"Adh4",	"Tmem64",	"Decr1",	"Enho",	"Sigmar1",	"Aldh1b1",	"Erp44",	"Hsdl2",	"Mup3",	"Mup21",	"Ccdc171",	"Plin2",	"Dab1",	"C8a",	"Cpt2",	"Pdzk1ip1",	"Cyp4a14",	"-//-",	"-//-",	"Cyp4a32",	"Serinc2",	"Paqr7",	"Il22ra1",	"Hmgcl",	"Slc25a34",	"Cd36",	"Gnai1",	"Hadha",	"Spon2",	"Agpat9",	"Hsd17b11",	"Acacb",	"Abcb9",	"Tpst1",	"Caln1",	"Hspb1",	"Mmd2",	"D630045J12Rik",	"Pdia4",	"Sspo",	"Osbpl3",	"Abcg2",	"Fabp1",	"Elmod3",	"Retsat",	"Mgll",	"Chchd6",	"Pdzrn3",	"Cxcl12",	"Zfp9",	"Clstn3",	"Lpcat3",	"Plbd1",	"Slco1a4",	"Nlrp12",	"Cacng7",	"Peg3",	"Nectin2",	"Lipe",	"Ech1",	"Lgals4",	"Csrp3",	"Pex11a",	"Wdr73",	"Ucp2",	"St5",	"Aqp8",	"Armcx3",	"Dusp8",	"Col4a1",	"Col4a2",	"6430573F11Rik",	"Mtnr1a",	"Acsl1",	"Tenm3",	"Spcs3",	"Slc25a42",	"Slc27a1",	"Lonp2",	"Zfp423",	"Ces1b",	"Ces1c",	"Ces1e",	"Herpud1",	"Vac14",	"Fbxo31",	"Cbfa2t3",	"Acsf3",	"Pknox2",	"Slc35f2",	"Anxa2",	"Fam81a",	"Elovl5",	"Fam46a",	"Me1",	"Nt5e",	"Manf",	"Slc25a20",	"Plxnb1",	"Cspg5",	"Acaa1b",	"-//-",	"Fam198a",	"Dcaf12l1",	"Arhgef9",	"Magt1"
)
###Just an example. Here we can make a new column of the genes that includes the ENREZID
eg=bitr(genes, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = "org.Mm.eg.db")
###we can convert these to any id included in the library
ids <- bitr(genes, fromType="SYMBOL", toType=c("ENTREZID", "ENSEMBL","SYMBOL"), OrgDb="org.Mm.eg.db")
head(ids)

#===================================================================================================#
###Do some actual analysis with clusterProfiler
###building a dataset for groupGO -- The input parameters of gene is a vector of gene IDs (anything accepted by OrgDb)

ids2<-ids[,c(2,3,1)]
ids3<-ids2[,1]
ggo <- groupGO(gene     = ids3,
               OrgDb    = org.Mm.eg.db,
               ont      = "CC",
               level    = 4,
               readable = TRUE)
head(ggo)

###Over-representation test(Boyle et al. 2004) were implemented in clusterProfiler. 
###For calculation details and explanation of paramters, please refer to the vignette of DOSE

ego <- enrichGO(gene          = ids3,
                #universe      = names(ids2),
                OrgDb         = org.Mm.eg.db,
                ont           = "CC",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.01,
                qvalueCutoff  = 0.05,
                readable      = TRUE)

head(ego)

###As I mentioned before, any gene ID type that supported in OrgDb can be directly used in GO analyses. 
###User need to specify the keyType parameter to specify the input gene ID type.

ego2 <- enrichGO(gene         = ids2$ENSEMBL,
                 OrgDb         = org.Mm.eg.db,
                 keyType       = 'ENSEMBL',
                 ont           = "CC",
                 pAdjustMethod = "BH",
                 pvalueCutoff  = 0.01,
                 qvalueCutoff  = 0.05)
head(ego2)

###Gene ID can be mapped to gene Symbol by using paramter readable=TRUE or setReadable function.

ego2 <- setReadable(ego2, OrgDb = org.Mm.eg.db)

###A common approach in analyzing gene expression profiles was identifying differential expressed 
###genes that are deemed interesting. The enrichment analysis we demonstrated previous were based on 
###these differential expressed genes. This approach will find genes where the difference is large, but 
###it will not detect a situation where the difference is small, but evidenced in coordinated way in a set of related genes.
###keep in mind that "male_transcriptomics_degs.csv" is is fold change, not quantity, so this file may need to be changed
###here I'm using FC for male KOs

###Example data###

library(org.Hs.eg.db)
ego3 <- gseGO(geneList     = geneList,
              OrgDb        = org.Hs.eg.db,
              ont          = "CC",
              nPerm        = 1000,
              minGSSize    = 100,
              maxGSSize    = 500,
              pvalueCutoff = 0.05,
              verbose      = FALSE)
head(ego3)

#===================================================================================================#
###Lets plot some crap###

barplot(ggo, drop=TRUE, showCategory=12)
dotplot(ego)
emapplot(ego)
cnetplot(ego, categorySize="pvalue")#, foldChange=geneList)

###END - THE REST ARE MY NOTES###
#===================================================================================================#

d = read.csv("geneList_134.csv")
## assume 1st column is ID
## 2nd column is FC
## feature 1: numeric vector
geneList = d[,2]
## feature 2: named vector
names(geneList) = as.character(d[,1])
## feature 3: decreasing order
geneList = sort(geneList, decreasing = TRUE)
eg=bitr(geneList, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = "org.Mm.eg.db")

ego3 <- gseGO(geneList     = geneList,
              OrgDb        = org.Mm.eg.db,
              ont          = "CC",
              nPerm        = 1000,
              minGSSize    = 100,
              maxGSSize    = 500,
              pvalueCutoff = 0.05,
              verbose      = FALSE)
head(ego3)


