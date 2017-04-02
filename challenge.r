library(rpart)
library(caret)
library(mlbench)
library(foreign)
library(nnet)
library(e1071)
library(randomForest)

setwd("C:\\workspace\\bioinformatics-sem2\\ml\\datachallenge")

all_data <- read.csv("Additional File DC2.csv")
data <- all_data[all_data$User.ID != 0 ,]
missing <- all_data[all_data$User.ID == 0 ,]

# Shuffle row indices and reorder data
rows <- sample(nrow(data))
data <- data[rows ,]

#split <- round(nrow(data) * .6)
train_set <- data[1:10, ]
test_set <- data[11:20,]
names(train_set)


#decision tree
print("Decision tree")
fit <- rpart(User.ID ~ Ip + Browser + Url, data = train_set,method="class")
summary(fit)
p <- predict(fit,test_set, type = "class")
table(p, test_set$User.ID)
confusionMatrix(p, test_set$User.ID)

#svm
fit <-svm(User.ID ~ Ip + Browser + Url, data = train_set)
summary(fit)
p <- predict(fit,test_set, type = "class")
table(p, test_set$User.ID)
confusionMatrix(p, test_set$User.ID)

#naive bayes
fit <-naiveBayes(User.ID ~ Ip + Browser + Url, data = train_set, type = "raw")
p <- predict(fit,test_set, type = "class")




