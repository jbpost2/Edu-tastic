source("uncdata.R")

library(caret)
library(elasticnet)

full_data %>%
  mutate(ps12 = Enroll.in.Postsecondary.within.12.months) %>%
  select(
    -year, 
    -County, 
    -AreaType, 
    -Enroll.in.Postsecondary.within.12.months
    )

index <- createDataPartition(y = full_data$ps12 , p = 0.8, list = FALSE)
trdata <- data.frame(full_data[index,])
tsdata <- data.frame(full_data[-index,])
 
trn <-
    train(
      ps12 ~ .,
      data = trdata,
      method = "enet",
      preProcess = c("center","scale"),
      trControl = trainControl(method = "cv", number = 10)
    )

pred <- predict(trn, newData = tsdata)
p2 <- round(postResample(pred, obs = tsdata$ps12),4)