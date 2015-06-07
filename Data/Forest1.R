#install.packages('party')
library(party)

source('setup.R')

set.seed(1)
forest1 <- cforest(as.factor(good) ~ latitude + longitude + width + height, data = train, controls = cforest_unbiased(ntree = 10, mtry = 2))

random_forest_result <- predict(forest1, test, OOB = TRUE, type = "response")
submit <- data.frame(Id = test$id, good = random_forest_result)

write.csv(submit, file = "CSV/random_forest.csv", row.names = FALSE)

