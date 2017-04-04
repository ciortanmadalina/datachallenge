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

setwd("C:\\workspace\\bioinformatics-sem2\\ml\\datachallenge")

input <- read.csv("Additional File DC2.csv")
all_data <- data.frame(row_id = input$ID.Rows)
all_data$user <- as.factor(input$User.ID)
all_data$url <- as.factor(input$Url)
all_data$domain <- as.factor(domain(input$Url))
all_data$ip <- as.factor(domain(input$Ip))
all_data$browser <- as.factor(domain(input$Browser))
all_data$from <- strptime(input$From, "%d/%m/%Y %H:%M")
all_data$start_hour <- as.factor(hour(all_data$from))
all_data$to <- strptime(input$To, "%d/%m/%Y %H:%M")

all_data$duration <- difftime(all_data$to, all_data$from, units = "mins")

count(is.na(all_data)) # there are 312 values with to undefined => this will mess up the duration
#Approach 1. default to date to from => 0 duration
all_data[is.na(all_data$duration), "duration"] = 0
#Approach 2. default to = from + mean(duration)
existingDurations <- all_data[!is.na(all_data$duration), "duration"]

all_data[is.na(all_data$duration), "duration"] = as.numeric(mean(existingDurations))

count(is.na(all_data))
all_data[is.na(all_data$to), ]

data <- all_data[all_data$user != 0 ,]
missing <- all_data[all_data$user == 0 ,]

# Shuffle row indices and reorder data
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



#naive bayes
fit <-naiveBayes(user ~ ip + domain + start_hour, data = train_set, type = "raw")
p <- predict(fit,test_set, type = "class")
table(p, test_set$user)
confusionMatrix(p, test_set$user)

fit <-naiveBayes(user ~ ip + domain + start_hour + duration, data = train_set, type = "raw")
p <- predict(fit,test_set, type = "class")
table(p, test_set$user)
confusionMatrix(p, test_set$user)






