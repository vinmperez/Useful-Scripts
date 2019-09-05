#########R Code to make a violin plot from a metabolomics dataset##########

setwd("C:/Users/vincent/Desktop/FB-CD-miceextracts-07312018-20181206T225525Z-001/FB-CD-miceextracts-07312018/")
dir()
library(ggplot2)

data<-read.csv("Exp134_metabolotes.csv", header=T)

#IGNORE: data$KO.Male<-as.factor(data$KO.Male)
#IGNORE: data$WT.Female.<-as.factor(data$WT.Female)
#IGNORE: data$KO.Female<-as.factor(data$KO.Female)

#Creates a seagreen violin plot on the log10 scale
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate)) + 
  geom_violin(fill="Seagreen")+ scale_y_log10();

#Creates a group-specific colored violin plot on the log10 scale
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill=Genotype)) + 
  geom_violin()+ scale_y_log10();

#Creates a group-specific colored violin plot on the log10 scale which is trimmed
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill=Genotype)) + 
  geom_violin(trim=FALSE)+ scale_y_log10();

#Creates a group-specific colored violin plot on the log10 scale which is trimmed
#However, now we have added mean and median values
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill=Genotype)) + 
  geom_violin(trim=FALSE)+ scale_y_log10() +
stat_summary(fun.y = "mean", geom = "point", shape = 8, size = 3, color = "midnightblue") +
  stat_summary(fun.y = "median", geom = "point", shape = 2, size = 3, color = "red")

#Creates a group-specific colored violin plot on the log10 scale which is trimmed
#However, now we have added boxplots denoting the mean
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill=Genotype)) + 
  geom_violin(trim=FALSE)+ scale_y_log10() +
  geom_boxplot(width=0.2);

#Creates a group-specific colored violin plot on the log10 scale which is trimmed
#However, now we have added boxplots denoting the mean, and moved the legend
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill=Genotype)) + 
  geom_violin(trim=FALSE)+ scale_y_log10() +
  geom_boxplot(width=0.2)+ 
  theme(legend.position = "top");

#now lets flip the plot
ggplot(data, aes(x = Genotype, y = X1.3.Dimethylurate, fill = Genotype)) + 
  geom_violin(trim=FALSE) + scale_y_log10() +
  geom_boxplot(width = 0.2) +
  coord_flip()

#now lets add more data...
ggplot(data, aes(x = Genotype, y = data[,2:3], fill = Genotype )) + 
  geom_violin(trim=FALSE) + scale_y_log10() +
  geom_boxplot(width = 0.2);
#...okay that didn't work

#lets try something new, you'll need to install the tidyr package for this
data %>% tidyr::gather("id", "value", 2:86) %>%
   ggplot(., aes(Genotype, value))+
   geom_point()+
   geom_smooth(method="lm",se=FALSE, color="black")+
   facet_wrap(~id);
#okay this works, don't delete it

#lets mix it up, you'll need the ggpubr package for this
#dodge <- position_dodge(width = 0.5)     #you can use this argument instead
#of position_dodge, but I don't recommend it
plot<-data %>% tidyr::gather("id", "value" , 2:4) %>%
  ggplot(., aes(id, value, fill=Genotype))+
  geom_violin(trim=FALSE, width=0.50, position = position_dodge(1), color="darkblue") +
  geom_boxplot(width=0.25, position = position_dodge(1))+
  ggpubr::rotate_x_text()+
  #facet_wrap(~id)
  #theme(axis.text.x=element_text(size=11)) +
  #theme(axis.title.x=element_text(size=14, face="bold")) +
  #theme(axis.title.y=element_text(size=14, face="bold")) +
  theme(legend.position="top")
  #theme(legend.text=element_text(size=12)) +
  #theme(legend.background = element_rect(fill="white")) +
  #theme(legend.key = element_blank()) 


#plot the median
plot + stat_summary(fun.y=median, geom="point", shape=23, size=2, position = dodge)

#or plot the mean
plot + stat_summary(fun.y=mean, geom="point", shape=23, size=2, color="red", position = dodge)

#or we can do it like this
plot + stat_summary(fun.data=mean_sdl, mult=1, 
                 geom="pointrange", color="red", position=dodge)

#here we can actually plot the data in dots; I prefer this
plot + geom_dotplot(binaxis='y', stackdir='center', dotsize=0.75, position=position_dodge(1))

