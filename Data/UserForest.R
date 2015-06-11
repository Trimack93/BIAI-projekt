#train <- read.csv("CSV/training.csv", stringsAsFactors = FALSE)

#U¿yj biblioteki
library(randomForest)

#commandArgs <- function() c(10, -90, -180, 480, 720, 23)

# Czytanie parametrów
args=(commandArgs())

treeNumber <-  as.numeric(args[1])

tmpLongitude = as.integer(args[3])
tmpLatitude <- as.integer(args[2])
tmpHeight <- as.integer(args[4])
tmpWidth <- as.integer(args[5])
tmpSize <- as.integer(args[6])

userInput[1,]$id <- as.integer(1)
userInput[1,]$latitude <- as.integer(tmpLatitude)
userInput[1,]$longitude <- as.integer(tmpLongitude)
userInput[1,]$width <- as.integer(tmpWidth)
userInput[1,]$height <- as.integer(tmpHeight)
userInput[1,]$size <- as.integer(tmpSize)


userInput$Continent = as.factor(userInput$Continent)
userInput$proportions = as.factor(userInput$proportions)

# Dodawanie leveli dla factorów
levels(userInput$Continent) <- c("North America", "South America", "Middle America", "Asia", "Europe", "Africa", "Ocean", "Australia")
levels(userInput$proportions) <- c("< 4:3", "4:3", "3:2", "> 3:2")

# Policz dodatkowe kolumny dla rekordu u¿ytkownika
userInput$Continent[userInput$longitude > -80 & userInput$longitude < -35 & userInput$latitude > -55 & userInput$latitude < 12] <- 'South America'
userInput$Continent[userInput$longitude > -115 & userInput$longitude < -60 & userInput$latitude > 12 & userInput$latitude < 30] <- 'Middle America'
userInput$Continent[userInput$longitude > -125 & userInput$longitude < -53 & userInput$latitude > 30 & userInput$latitude < 80] <- 'North America'
userInput$Continent[userInput$longitude > -168 & userInput$longitude < -125 & userInput$latitude > 50 & userInput$latitude < 72] <- 'North America'
userInput$Continent[userInput$longitude >  113 & userInput$longitude < 168 & userInput$latitude > -48 & userInput$latitude < -12] <- 'Australia'
userInput$Continent[userInput$longitude > -10 & userInput$longitude < 40 & userInput$latitude > 36 & userInput$latitude < 72] <- 'Europe'
userInput$Continent[userInput$longitude > -18 & userInput$longitude < 35 & userInput$latitude > 5 & userInput$latitude < 36] <- 'Africa'
userInput$Continent[userInput$longitude > 50 & userInput$longitude < 10 & userInput$latitude > -35 & userInput$latitude < 5] <- 'Africa'
userInput$Continent[userInput$longitude > 35 & userInput$longitude < -50 & userInput$latitude > 13 & userInput$latitude < 0] <- 'Africa'
userInput$Continent[userInput$longitude > 40 & userInput$longitude < 145 & userInput$latitude > 30 & userInput$latitude < 85] <- 'Asia'
userInput$Continent[userInput$longitude > 35 & userInput$longitude < 125 & userInput$latitude > 10 & userInput$latitude < 40] <- 'Asia'
userInput$Continent[userInput$longitude > 30 & userInput$longitude < 85 & userInput$latitude > -10 & userInput$latitude < 20] <- 'Asia'
userInput$Continent[userInput$longitude > 140 & userInput$longitude < 180 & userInput$latitude > 50 & userInput$latitude < 75] <- 'Asia'
userInput$Continent[is.na(userInput$Continent)] <- 'Ocean'

userInput$proportions[(userInput$width / userInput$height) < 1.33] <- '< 4:3'
userInput$proportions[(userInput$width / userInput$height) >= 1.33] <- '4:3'
userInput$proportions[(userInput$width / userInput$height) >= 1.45] <- '3:2'
userInput$proportions[(userInput$width / userInput$height) >= 1.55] <- '> 3:2'

userInput$resolution <- as.integer(sqrt(userInput$height^2 + userInput$width^2))

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
write.csv(submit3, file = "CSV/userInput.csv", row.names = FALSE)

# Ustawia zmienn¹, do której mo¿e sobie siêgn¹æ r.net
userResult <- as.integer(submit3[1,2])
userResult <- userResult - 1
  