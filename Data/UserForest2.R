#train <- read.csv("CSV/training.csv", stringsAsFactors = FALSE)

#U¿yj biblioteki
library(randomForest)

#commandArgs <- function() c(10, -90, -180, 480, 720, 23)

source('LoadUserRecord.R')

# Tylko do sprawdzania, czy dobrze przekazano parametry
sink(file = "output.txt")
for (i in 1:length(args))
{
  cat(args[i])
  cat('\n')
}
sink()

# Miejscowy random
set.seed(1)

# Stwórz las drzew decyzyjnych
forest2 <- randomForest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions, data = train, mtry = 3, importance=TRUE, ntree= treeNumber)

# Dokonaj predykcji
random_forest_result3 <- predict(forest2, userInput, OOB = TRUE, type = "response")

# Zapisz wyniki do pliku
submit3 <- data.frame(Id = userInput$id, good = random_forest_result3)
  
# Ustawia zmienn¹, do której mo¿e sobie siêgn¹æ r.net
userResult <- as.integer(submit3[1,2])
userResult <- userResult - 1
  