#train <- read.csv("CSV/training.csv", stringsAsFactors = FALSE)

#U¿yj biblioteki
library(randomForest)

commandArgs <- function() c(20, 25, 14, 720, 480, 23)

# Czytanie parametrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

tmpLongitude = as.numeric(args[3])
tmpLatitude <- as.numeric(args[2])
tmpHeight <- as.numeric(args[4])
tmpWidth <- as.numeric(args[5])
tmpSize <- as.numeric(args[6])

userInput[1,]$id <- as.integer(1)
userInput[1,]$latitude <- tmpLatitude
userInput[1,]$longitude <- tmpLongitude
userInput[1,]$width <- tmpWidth
userInput[1,]$height <- tmpHeight
userInput[1,]$size <- tmpSize

# Policz dodatkowe kolumny dla rekordu u¿ytkownika
userInput$Continent <- 'Ocean'
userInput$Continent[userInput$longitude > -80 & userInput$longitude < -35 & userInput$latitude > -55 & userInput$latitude < 12] <- 'South America'
userInput$Continent[userInput$longitude > -115 & userInput$longitude < -60 & userInput$latitude > 12 & userInput$latitude < 30] <- 'Middle America'
userInput$Continent[userInput$longitude > -125 & userInput$longitude < -53 & userInput$latitude > 30 & userInput$latitude < 80] <- 'North America'
userInput$Continent[userInput$longitude > -168 & userInput$longitude < -125 & userInput$latitude > 50 & userInput$latitude < 72] <- 'South America'
userInput$Continent[userInput$longitude >  113 & userInput$longitude < 168 & userInput$latitude > -48 & userInput$latitude < -12] <- 'Australia'
userInput$Continent[userInput$longitude > -10 & userInput$longitude < 40 & userInput$latitude > 36 & userInput$latitude < 72] <- 'Europe'
userInput$Continent[userInput$longitude > -18 & userInput$longitude < 35 & userInput$latitude > 5 & userInput$latitude < 36] <- 'Africa'
userInput$Continent[userInput$longitude > 50 & userInput$longitude < 10 & userInput$latitude > -35 & userInput$latitude < 5] <- 'Africa'
userInput$Continent[userInput$longitude > 35 & userInput$longitude < -50 & userInput$latitude > 13 & userInput$latitude < 0] <- 'Africa'
userInput$Continent[userInput$longitude > 40 & userInput$longitude < 145 & userInput$latitude > 30 & userInput$latitude < 85] <- 'Asia'
userInput$Continent[userInput$longitude > 35 & userInput$longitude < 125 & userInput$latitude > 10 & userInput$latitude < 40] <- 'Asia'
userInput$Continent[userInput$longitude > 30 & userInput$longitude < 85 & userInput$latitude > -10 & userInput$latitude < 20] <- 'Asia'
userInput$Continent[userInput$longitude > 140 & userInput$longitude < 180 & userInput$latitude > 50 & userInput$latitude < 75] <- 'Asia'

userInput$proportions[(userInput$width / userInput$height) < 1.33] <- '< 4:3'
userInput$proportions[(userInput$width / userInput$height) >= 1.33] <- '4:3'
userInput$proportions[(userInput$width / userInput$height) >= 1.45] <- '3:2'
userInput$proportions[(userInput$width / userInput$height) >= 1.55] <- '> 3:2'

userInput$resolution <- as.integer(sqrt(userInput$height^2 + userInput$width^2))

userInput$Continent = as.factor(userInput$Continent)
userInput$proportions = as.factor(userInput$proportions)

# Tylko do sprawdzania, czy dobrze przekazano parametry
sink(file = "output.txt")
for (i in 1:length(args))
{
  cat(args[i])
  cat('\n')
  cat(userInput$latitude)
  cat('\n')
  cat(userInput$Continent)
}
sink()

# Miejscowy random
set.seed(1)

# Stwórz las drzew decyzyjnych
forest2 <- randomForest(as.factor(good) ~ size + latitude + longitude + width + height, data = train, mtry = 3, importance=TRUE, ntree= treeNumber)

# Dokonaj predykcji
random_forest_result3 <- predict(forest2, userInput, OOB = TRUE, type = "response")

# Zapisz wyniki do pliku
submit3 <- data.frame(Id = userInput$id, good = random_forest_result3)
write.csv(submit3, file = "CSV/userInput.csv", row.names = FALSE)

# Ustawia zmienn¹, do której mo¿e sobie siêgn¹æ r.net
userResult <- submit3[1,2]
