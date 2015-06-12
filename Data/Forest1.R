#install.packages('party')
library(party)

train.sub <- subset(train, train$id > 35000)
test.sub <- subset(test, test$id > 50000)

set.seed(1)
forest1 <- cforest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions + nameLength + captionLength + descriptionLength, data=train, controls = cforest_unbiased(ntree = 10, mtry = 11))

random_forest_result <- predict(forest1, test.sub, OOB = TRUE, type = "response")
submit <- data.frame(Id = test.sub$id, good = random_forest_result)

write.csv(submit, file = "CSV/random_forest.csv", row.names = FALSE)

prop.table(table(submit$good))

