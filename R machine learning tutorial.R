#####################TUTORIAL FOR MACHINE LEARNING IN R##############################################
#===================================================================================================#
###Install caret, the most frequently used machine learning package in R.
install.packages("caret", dependencies=c("Depends", "Suggests"))
library(caret)
#===================================================================================================#
###Load the dataset, iris.csv, which is a bunch of data on 3 flower species.
setwd("C:/Users/vincent/Desktop/")
filename<-"iris.csv"
dataset<-read.csv(filename,header=FALSE)
colnames(dataset)<-c("Sepal.length", "Sepal.width", "Petal.length","Petal.width","Species")
#===================================================================================================#
###Create a list from 80% of the rows of the original dataset we can use for model training, while 
###leaving the remaining 20% for testing the model at the end.
validation_index <- createDataPartition(dataset$Species, p=0.80, list=FALSE)
# select 20% of the data for validation
validation <- dataset[-validation_index,]
# use the remaining 80% of data to training and testing the models
dataset <- dataset[validation_index,]
###Note that we replaced our 'dataset' variable with the 80% sample of the dataset. This 
###was an attempt to keep the rest of the code simpler and readable.
#===================================================================================================#
###Now it is time to take a look at the data dimensions and stuff.
###In this step we are going to take a look at the data a few different ways:
###1 - Dimensions of the dataset.
###2 - Types of the attributes.
###3 - Peek at the data itself.
###4 - Levels of the class attribute.
###5 - Breakdown of the instances in each class.
###6 - Statistical summary of all attributes.
dim(dataset)
####list types for each attribute
sapply(dataset, class)
###take a peek at the first 5 rows of the data
head(dataset)
###list the levels for the class
levels(dataset$Species)
###summarize the class distribution
percentage <- prop.table(table(dataset$Species)) * 100
cbind(freq=table(dataset$Species), percentage=percentage)
###summarize attribute distributions
summary(dataset)
#===================================================================================================#
###Lets make some plots to visualize the datasets
###We now have a basic idea about the data. We need to extend that with some 
###visualizations.
###We are going to look at two types of plots:
###Univariate plots to better understand each attribute.
###Multivariate plots to better understand the relationships between attributes.
###split input and output
x <- dataset[,1:4]
y <- dataset[,5]
###boxplot for each attribute on one image
par(mfrow=c(1,4))
for(i in 1:4) {
  boxplot(x[,i], main=names(iris)[i])
}
###boxplot for each attribute on one image
par(mfrow=c(1,4))
for(i in 1:4) {
  boxplot(x[,i], main=names(iris)[i])
}
###barplot for class breakdown
plot(y)
###scatterplot matrix
featurePlot(x=x, y=y, plot="ellipse")
###box and whisker plots for each attribute
###density plots for each attribute by class value
scales <- list(x=list(relation="free"), y=list(relation="free"))
featurePlot(x=x, y=y, plot="density", scales=scales)
#===================================================================================================#
###Now to get into some machine learning stuff
###Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
###Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
###Build the models
###a) linear algorithms
set.seed(7)
fit.lda <- train(Species~., data=dataset, method="lda", metric=metric, trControl=control)
###b) nonlinear algorithms
###CART
set.seed(7)
fit.cart <- train(Species~., data=dataset, method="rpart", metric=metric, trControl=control)
###kNN
set.seed(7)
fit.knn <- train(Species~., data=dataset, method="knn", metric=metric, trControl=control)
###c) advanced algorithms
###SVM
set.seed(7)
fit.svm <- train(Species~., data=dataset, method="svmRadial", metric=metric, trControl=control)
###Random Forest
set.seed(7)
fit.rf <- train(Species~., data=dataset, method="rf", metric=metric, trControl=control)
###summarize accuracy of models
results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)
###compare accuracy of models, but first call the package lattice to use its function dotplot
lattice::dotplot(results)
###summarize Best Model, which turned out to be lda
print(fit.lda)
#===================================================================================================#
###Make Predictions
###The LDA was the most accurate model. Now we want to get an 
###idea of the accuracy of the model on our validation set.
###This will give us an independent final check on the accuracy of the best model. 
###It is valuable to keep a validation set just in case you made a slip during 
###such as overfitting to the training set or a data leak. Both will result in an overly optimistic result.
###We can run the LDA model directly on the validation set and summarize the results 
###in a confusion matrix.
###estimate skill of LDA on the validation dataset
predictions <- predict(fit.lda, validation)
confusionMatrix(predictions, validation$Species)
#===================================================================================================#
###Summary
###In this post you discovered step-by-step how to complete your 
###first machine learning project in R.
###You discovered that completing a small end-to-end project from 
###loading the data to making predictions is the best way to get familiar with a new platform.
###Your Next Step
###Do you work through the tutorial?
###Work through the above tutorial.
###List any questions you have.
###Search or research the answers.
