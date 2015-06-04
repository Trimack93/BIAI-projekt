setwd("E:/Git/BIAI-projekt/Data")

train <- read.csv("CSV/training.csv", stringsAsFactors = FALSE)
test <- read.csv("CSV/test.csv", stringsAsFactors = FALSE)

# Info o tabeli
str(train)

# Iloœæ dobrych i z³ych zdjêæ
table(train$good)

# Proporcje dobrych i z³ych zdjêæ
prop.table(table(train$good))

# Dodanie nowej kolumny i wype³nienie zertami
test$good <- rep(0, 12000)

# Stworzenie nowego dataFrame'u na podstawie test.csv
submit <- data.frame(PhotoId = test$id, good = test$good)

# Stworzenie pliku na podstawie submit
write.csv(submit, file="CSV/beginning.csv", row.names = FALSE)

summary(train$size)

# "Skrypt w skrypcie"
source('test.R')
