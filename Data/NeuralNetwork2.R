#install.packages("nnet")

library(nnet)
require(quantmod) #for Lag()
require(caret)


set.seed(1)

comb <- rbind(train, test)

ir.nn2 <- nnet(good ~ longitude + latitude + width + height + size, data = comb, subset = comb$id < 40000, size = 2, rang = 0.1, decay = 5e-4, maxit = 200)

table(comb$good[comb$id > 40000], predict(ir.nn2, comb[comb$id > 40000], type = "class"))

predict(ir.nn2, comb[comb$id > 40000], type = "class")

table(comb$good[comb$id > 40000])

submit4 <-  data.frame(Id = test$id, ir.nn2)

install.packages("caret")


#Fit model
model <- train(good ~ longitude + latitude + width + height + size, comb, method='nnet', linout=TRUE, trace = FALSE,
               #Grid of tuning parameters to try:
               tuneGrid=expand.grid(.size=c(1,5,10),.decay=c(0,0.001,0.1))) 
ps <- predict(model, comb)

#Examine results
model
plot(good)
lines(ps, col=2)