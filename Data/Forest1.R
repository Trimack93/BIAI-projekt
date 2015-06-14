#install.packages('party')
library(party)

# Czytanie parametrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

train.sub <- subset(train, train$id > 30000)
test.sub <- subset(test, test$id > 50000)

set.seed(1)
forest1 <- cforest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions + nameLength + captionLength + descriptionLength, data=train.sub, controls = cforest_unbiased(ntree = 20, mtry = 10))

random_forest_result <- predict(forest1, test, OOB = TRUE, type = "response")
submit <- data.frame(Id = test$id, good = random_forest_result)

write.csv(submit, file = "CSV/random_forest.csv", row.names = FALSE)

prop.table(table(submit$good))

