library(rpart)
library(caret)
library(mlbench)
library(foreign)
library(nnet)
library(e1071)
library(randomForest)
library(urltools)
library(ggplot2)
library(lubridate)
library(plyr)
library(e1071)

rm(list=ls(all=TRUE))
setwd("C:\\workspace\\bioinformatics-sem2\\ml\\datachallenge")

input <- read.csv("Additional File DC2.csv")
all_data <- data.frame(row_id = input$ID.Rows)
all_data$user <- as.factor(input$User.ID)
all_data$url <- as.factor(input$Url)
all_data$domain <- as.factor(domain(input$Url))
all_data$ip <- as.factor(domain(input$Ip))
all_data$from <- strptime(input$From, "%d/%m/%Y %H:%M")
all_data$start_hour <- as.factor(hour(all_data$from))
to <- strptime(input$To, "%d/%m/%Y %H:%M")
all_data$duration <- difftime(to, all_data$from, units = "mins")

count(is.na(all_data)) # there are 312 values with to undefined => this will mess up the duration
#default to date to from => 0 duration
all_data[is.na(all_data$duration), "duration"] = 0
#make sure there is no missing data
apply(all_data, 2, function(x) sum(any(is.na(x))))

count(is.na(all_data))
all_data[is.na(all_data$to), ]

data <- all_data[all_data$user != 0 ,]
missing <- all_data[all_data$user == 0 ,]

# Shuffle row indices and reorder data
set.seed(42)
rows <- sample(nrow(data))
data <- data[rows ,]

# Identify row to split on: split
split <- round(nrow(data) * 0.6)

train_set <- data[1 : split, ]
test_set <- data[(split + 1) : nrow(data), ]


nrow(train_set)
nrow(test_set)


ggplot(train_set, aes(x=domain)) +
  geom_bar(aes(fill=user)) +
  scale_fill_brewer(palette = "Spectral")

ggplot(data, aes(x=start_hour)) +
  geom_bar(aes(fill=user)) +
  facet_grid(user ~ .)

ggplot(data, aes(x=duration)) +
  geom_bar(aes(fill=user)) +
  facet_grid(user ~ .)


ggplot(data, aes(start_hour,fill = factor(user))) +
  geom_histogram(stat = "count")


#naive bayes
fit_nb <-naiveBayes(user ~ ip + domain + start_hour, data = train_set, type = "raw")
p_nb <- predict(fit_nb,test_set, type = "class")
table(p_nb, test_set$user)
confusionMatrix(p_nb, test_set$user)#Accuracy : 0.8188 


#decision tree
fit_dt <- rpart(user ~ ip + domain + start_hour, data = train_set)


#svm
fit_svm <- svm(user ~ ip + domain + start_hour, data = train_set)
p_svm <- predict(fit_svm,test_set)
table(p_svm, test_set$user)
confusionMatrix(p_svm, test_set$user)#Accuracy : 0.6652  


# random forest
library('randomForest')
fit_rf <- randomForest(factor(user) ~ ip + start_hour,data = train_set)
p_rf <- predict(fit_rf,test_set)
table(p_rf, test_set$user)
confusionMatrix(p_rf, test_set$user) #Accuracy : 0.7528  

#glmnet
myControl <- trainControl(
  method = "cv", 
  number = 5,
  verboseIter = TRUE
)
glm_model <- train(factor(user) ~ ip + domain + start_hour, 
  method = "glmnet",
  data = train_set,
  trControl = myControl,
  tuneGrid = expand.grid(alpha = 0:1,
                         lambda = seq(0.001, 1, length = 5))
)

p_glm <- predict(glm_model,test_set)
table(p_glm, test_set$user)
confusionMatrix(p_glm, test_set$user) #Accuracy : 0.8545  

head(input[as.character(input$events) != "", "events"])
head(input[as.character(input$media) != "", "media"])





