install.packages('rattle')
install.packages('rpart.plot')
install.packages('RColorBrewer')
library(rattle)
library(rpart.plot)
library(RColorBrewer)

library(rpart)

setwd("E:/Git/BIAI-projekt/Data")

train <- read.csv("CSV/training.csv", stringsAsFactors = FALSE)
test <- read.csv("CSV/test.csv", stringsAsFactors = FALSE)

# Info o tabeli
str(train)

# Iloœæ dobrych i z³ych zdjêæ
table(train$good)

# Proporcje dobrych i z³ych zdjêæ
prop.table(table(train$good))

# Dodanie nowej kolumny i wype³nienie zertami
test$good <- rep(0, 12000)

# Stworzenie nowego dataFrame'u na podstawie test.csv
submit <- data.frame(PhotoId = test$id, good = test$good)

# Stworzenie pliku na podstawie submit
write.csv(submit, file="CSV/beginning.csv", row.names = FALSE)

summary(train$width)

# "Skrypt w skrypcie"
source('test.R')

prop.table(table(train$latitude, train$good), 1)

train$y <- ' > 70'
train$y[train$latitude < 70 & train$latitude >= 60] <- '<60,70)'
train$y[train$latitude < 60 & train$latitude >= 50] <- '<50,60)'
train$y[train$latitude < 50 & train$latitude >= 40] <- '<40,50)'
train$y[train$latitude < 40 & train$latitude >= 30] <- '<30,40)'
train$y[train$latitude < 30 & train$latitude >= 20] <- '<20,30)'
train$y[train$latitude < 20 & train$latitude >= 10] <- '<10,20)'
train$y[train$latitude < 10 & train$latitude >= 0] <- '<0,10)'
train$y[train$latitude < 0 & train$latitude >= -10] <- '<-10,0)'
train$y[train$latitude < -10 & train$latitude >= -20] <- '<-20,-10)'
train$y[train$latitude < -20 & train$latitude >= -30] <- '<-20,-30)'
train$y[train$latitude < -30 & train$latitude >= -20] <- '<-30,-40)'
train$y[train$latitude < -40 & train$latitude >= -50] <- '<-40,-50)'
train$y[train$latitude < -50 & train$latitude >= -60] <- '<-50,-60)'
train$y[train$latitude < -60 & train$latitude >= -70] <- '<-60,70)'
train$y[train$latitude < -70] <- ' < -70'
#train$Fare2[train$Fare < 10] <- '<10'

train$resolution <- sqrt(train$height^2 + train$width^2)


prop.table(table(train$y, train$good), 1)

train$latitude <- train$latitude - 90

aggregate(good ~ y, data=train, FUN=function(x){sum(x)/length(x)})

tree1 <- rpart(good ~ resolution + width + height, data=train, method = "class", control=rpart.control(minsplit=2000, cp=0,9))

#new.tree1 <- prp(tree1,snip=TRUE)$obj
fancyRpartPlot(tree1)

#test$good <- NA
#combi <- rbind(train, test)

#combi$name = as.array(combi$name)
#combi$name[1]

#strsplit(combi$name[1], split=' ')[[1]][2]

install.packages('party')
library(party)

set.seed(1)
forest1 <- cforest(as.factor(good) ~ latitude + longitude + resolution, data = train, controls = cforest_unbiased(ntree = 10, mtry = 2))

random_forest_result <- predict(forest1, test, OOB = TRUE, type = "response")
submit <- data.frame(Id = test$id, good = random_forest_result)

write.csv(submit, file = "CSV/random_forest.csv", row.names = FALSE)

prop.table(table(train$good))

prop.table(table(submit$good))

#install.packages(ggplot2)

install.packages("randomForest")

library(ggplot2)
library(randomForest)
        
set.seed((1))

test$resolution <- rep(0, 12000)
test$resolution <- sqrt(test$height^2 + test$width^2)

forest2 <- randomForest(as.factor(good) ~ latitude + longitude + resolution, data = train, importance=TRUE, ntree=20)
random_forest_result2 <- predict(forest1, test, OOB = TRUE, type = "response")
submit2 <- data.frame(Id = test$id, good = random_forest_result2)
write.csv(submit, file = "CSV/random_forest2.csv", row.names = FALSE)
prop.table(table(submit2$good))
