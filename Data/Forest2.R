#install.packages("randomForest")

#U¿yj biblioteki
library(randomForest)

# Za³aduj dane
source('setup.R')

# Czytanie paranetrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

# Tylko do sprawdzania, czy dobrze przekazano parametry
sink(file = "output.txt")
cat(treeNumber)
sink()

# Miejscowy random
set.seed(1)

# Stwórz las drzew decyzyjnych
forest2 <- randomForest(as.factor(good) ~ latitude + longitude + width + height, data = train, importance=TRUE, ntree=100)

# Dokonaj analizy danych na podstawie lasu
random_forest_result2 <- predict(forest2, test, OOB = TRUE, type = "response")

# Stwórz plik wynikowy
submit2 <- data.frame(Id = test$id, good = random_forest_result2)
write.csv(submit2, file = "CSV/random_forest2.csv", row.names = FALSE)
