library(caret)
library(ROSE)
library(DMwR2)

###VIEW THE AVAILABLE MODELS IN CARET
models= getModelInfo()
names(models)
###########################################################
mdata = read.csv("Malaria-Data.csv", header = TRUE)
dim(mdata)
mdata
head(mdata)
names(mdata)
#str(odata)
#attach(mdata)
summary(mdata) ###Descriptive Statistics
#describe(mdata)###Descriptive Statistics
sum(is.na(mdata))###Check for missing data
####################################################################
###Rename the classes of the Target variable and plot it to determine imbalance
mdata$severe_maleria <- factor(mdata$severe_maleria, 
                               levels = c(0,1), 
                               labels = c('Not Severe', 'Severe'))
###Plot Target Variable
plot(factor(severe_maleria), names= c('Not Severe', 'Severe'), col=c(2,3), ylim=c(0, 600), ylab='Respondent', xlab='Malaria Diagnosis')
box()
#Or use ggplot 
ggplot(mdata, aes(x = factor(severe_maleria))) + geom_bar() + labs(x = "Malaria Detected", y = "Count")

#Data partition
set.seed(123)
trainIndex <- createDataPartition(mdata$severe_maleria, p = 0.75, list = FALSE)
train <- mdata[trainIndex, ]
test <- mdata[-trainIndex, ]
dim(train)
dim(test)

train$severe_maleria <- as.factor(train$severe_maleria)
test$severe_maleria <- as.factor(test$severe_maleria)

#  Define the hyperparameter grid
tuneGrid_dt <- expand.grid(cp = seq(0.01, 0.1, by = 0.01))
# Set up cross-validation
control <- trainControl(method = "cv", number = 10)
#Train the Decision Tree model
set.seed(123)
dtModel <- train(factor(severe_maleria) ~ ., data = train, 
                 method = "rpart", 
                 trControl = control,
                 tuneGrid = tuneGrid_dt)

#Print the results of the trained model
print(dtModel)
##############################################################
#Plot the results to visualize the performance across different hyperparameter values
plot(dtModel)
#Make predictions on the test set
predictions <- predict(dtModel, newdata = test)
#Evaluate the performance using a confusion matrix
confMatrix <- confusionMatrix(predictions, as.factor(test$severe_maleria))
print(confMatrix)
# Load the rpart.plot package for tree visualization
#install.packages("rpart.plot")
library(rpart)
library(rpart.plot)
#Plot the decision tree
rpart.plot(dtModel$finalModel)

##################################################################

# Load necessary libraries
library(caret)
library(ROSE)
library(DMwR2)
library(ggplot2)
library(rpart)
library(rpart.plot)

# View the available models in caret
models <- getModelInfo()
names(models)

# Load the dataset
mdata <- read.csv("Malaria-Data.csv", header = TRUE)

# Explore the dataset
dim(mdata)
head(mdata)
names(mdata)
summary(mdata)  # Descriptive statistics
sum(is.na(mdata))  # Check for missing data

# Rename the classes of the target variable and plot it to determine imbalance
###Rename the classes of the Target variable and plot it to determine imbalance
mdata$severe_maleria <- factor(mdata$severe_maleria, 
                               levels = c(0,1), 
                               labels = c('Not Severe', 'Severe'))
###Plot Target Variable
plot(factor(severe_maleria), names= c('Not Severe', 'Severe'), col=c(2,3), ylim=c(0, 600), ylab='Respondent', xlab='Malaria Diagnosis')
box()
#Or use ggplot 
ggplot(mdata, aes(x = factor(severe_maleria))) + geom_bar() + labs(x = "Malaria Detected", y = "Count")

# Data partition
set.seed(123)
trainIndex <- createDataPartition(mdata$severe_maleria, p = 0.75, list = FALSE)
train <- mdata[trainIndex, ]
test <- mdata[-trainIndex, ]
dim(train)
dim(test)

train$severe_maleria <- as.factor(train$severe_maleria)
test$severe_maleria <- as.factor(test$severe_maleria)

# Define the hyperparameter grid
tuneGrid_dt <- expand.grid(cp = seq(0.01, 0.1, by = 0.01))

# Set up cross-validation
control <- trainControl(method = "cv", number = 10)

# Train the Decision Tree model
set.seed(123)
dtModel <- train(severe_malaria ~ ., data = train, 
                 method = "rpart", 
                 trControl = control,
                 tuneGrid = tuneGrid_dt)

# Print the results of the trained model
print(dtModel)

# Plot the results to visualize the performance across different hyperparameter values
plot(dtModel)

# Make predictions on the test set
predictions <- predict(dtModel, newdata = test)

# Evaluate the performance using a confusion matrix
confMatrix <- confusionMatrix(predictions, test$severe_malaria)
print(confMatrix)

# Plot the decision tree
rpart.plot(dtModel$finalModel)

