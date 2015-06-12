#install.packages('neuralnet')

# Za³adowanie referencji
library(neuralnet)

norm.fun = function(x){(x - min(x))/(max(x) - min(x))}
train.norm = apply(train[,2:6], 2, norm.fun)

neural <- neuralnet(good ~ longitude + latitude + width + height + size, data=train, hidden = 5, stepmax = 1000000, threshold = 0.01, linear.output = FALSE)

plot(neural)

columns <- c("latitude","longitude","width","height", "size")
covariate <- subset(test, select = columns)

# Stwórz plik wynikowy
neural_result <- compute(neural, covariate)

submit3 <- data.frame(Id = test$id, neural_result$net.result)
write.csv(submit3, file = "CSV/neural_network.csv", row.names = FALSE)

prop.table(table(submit3$good))

table(submit3$good)
