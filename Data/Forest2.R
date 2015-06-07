#install.packages("randomForest")

#U¿yj biblioteki
library(randomForest)

# Za³aduj dane
source('setup.R')

# Czytanie parametrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

if (length(commandArgs()) > 2) 
{
  tmpLongitude = as.numeric(args[3])
  tmpLatitude <- as.numeric(args[2])
  tmpHeight <- as.numeric(args[4])
  tmpWidth <- as.numeric(args[5])
  tmpSize <- as.numeric(args[6])
  
  userInput = data.frame(matrix(NA, nrow = 1, ncol = 10))
  dim(userInput)
  names(userInput) <- colnames(train)
  userInput[1,]$id <- as.integer(1)
  userInput[1,]$latitude <- tmpLatitude
  userInput[1,]$longitude <- tmpLongitude
  userInput[1,]$width <- tmpWidth
  userInput[1,]$height <- tmpHeight
  userInput[1,]$size <- tmpSize
  
}


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
forest2 <- randomForest(as.factor(good) ~ latitude + longitude + width + height, data = train, importance=TRUE, ntree=100)

# Dokonaj analizy danych na podstawie lasu
random_forest_result2 <- predict(forest2, test, OOB = TRUE, type = "response")

# Stwórz plik wynikowy
submit2 <- data.frame(Id = test$id, good = random_forest_result2)
write.csv(submit2, file = "CSV/random_forest2.csv", row.names = FALSE)

#To samo, tylko dla danych u¿ytkownika
if (length(commandArgs()) > 2) 
{
  random_forest_result3 <- predict(forest2, userInput, OOB = TRUE, type = "response")
  
  submit3 <- data.frame(Id = userInput$id, good = random_forest_result3)
  write.csv(submit3, file = "CSV/userInput.csv", row.names = FALSE)
}