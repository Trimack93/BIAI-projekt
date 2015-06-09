#install.packages("randomForest")

#U¿yj biblioteki
library(randomForest)

# Czytanie parametrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

# Tylko do sprawdzania, czy dobrze przekazano parametry
sink(file = "output.txt")
for (i in 1:length(args))
{
  cat(args[i])
  cat('\n')
}
sink()

# Miejscowy random
set.seed(4)

# Stwórz las drzew decyzyjnych
forest2 <- randomForest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions, data = train, mtry = 3, importance=TRUE, ntree= 100)

# Wypisanie wa¿noœci poszczególnych parametrów podczas podejmowania decyzji
importance(forest2)
varImpPlot(forest2)

# Dokonaj analizy danych na podstawie lasu
random_forest_result2 <- predict(forest2, test, OOB = TRUE, type = "response")

# Stwórz plik wynikowy
submit2 <- data.frame(Id = test$id, good = random_forest_result2)
write.csv(submit2, file = "CSV/random_forest2.csv", row.names = FALSE)

prop.table(table(submit2$good))
