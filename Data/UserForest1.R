#U¿yj biblioteki
library(party)

#commandArgs <- function() c(10, -90, -180, 480, 720, 23)

#source('ExtraColumns.R')

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
set.seed(5)

# Stwórz las
forest1 <- cforest(as.factor(good) ~ Continent + resolution + size + latitude + longitude + width + height + proportions, data=train, controls = cforest_unbiased(ntree = 10, mtry = 3))

# Dokonaj predykcji i zapisz wynik
random_forest_result4 <- predict(forest1, userInput, OOB = TRUE, type = "response")
submit4 <- data.frame(Id = userInput$id, good = random_forest_result4)

write.csv(submit4, file = "CSV/userInput.csv", row.names = FALSE)

# Ustawia zmienn¹, do której mo¿e sobie siêgn¹æ r.net
userResult <- as.integer(submit4[1,2])
userResult <- userResult - 1