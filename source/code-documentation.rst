Code Documentation
==================

This document explains the R code used in the Malaria Data Analysis project step by step.

1. **Load Necessary Libraries**
   The first step is to load the required libraries, which provide functions for data preprocessing, visualization, and modeling.

   .. code-block:: r

      library(caret)        # Provides tools for data partitioning, model training, and evaluation.
      library(ROSE)         # Used for handling class imbalance in datasets.
      library(DMwR2)        # Provides tools for data mining and handling imbalanced datasets.
      library(ggplot2)      # Used for data visualization.
      library(rpart)        # Used to build decision tree models.
      library(rpart.plot)   # Used to visualize decision trees.

2. **Explore Available Models in caret**
   The caret library contains a variety of machine learning models. This step lists all available models.

   .. code-block:: r

      models <- getModelInfo()  # Retrieves a list of all supported models in caret.
      names(models)             # Displays the names of the available models.

3. **Load and Explore the Dataset**
   The dataset is loaded from a CSV file and basic exploratory analysis is conducted.

   .. code-block:: r

      mdata <- read.csv("Malaria-Data.csv", header = TRUE)  # Loads the dataset.

      # Explore the dataset
      dim(mdata)               # Displays the number of rows and columns.
      head(mdata)              # Displays the first few rows of the dataset.
      names(mdata)             # Lists the column names.
      summary(mdata)           # Provides descriptive statistics for each column.
      sum(is.na(mdata))        # Checks for missing values in the dataset.

4. **Rename the Target Variable Classes**
   The target variable (`severe_maleria`) is converted into a factor with meaningful labels to make it easier to interpret.

   .. code-block:: r

      mdata$severe_maleria <- factor(mdata$severe_maleria, 
                                     levels = c(0, 1), 
                                     labels = c('Not Severe', 'Severe'))

5. **Visualize the Target Variable**
   To understand the distribution of the target variable, a bar plot is created.

   .. code-block:: r

      # Using the base R plotting system
      plot(factor(mdata$severe_maleria), 
           names = c('Not Severe', 'Severe'), 
           col = c(2, 3), 
           ylim = c(0, 600), 
           ylab = 'Respondent', 
           xlab = 'Malaria Diagnosis')
      box()

      # Using ggplot2 for visualization
      ggplot(mdata, aes(x = factor(severe_maleria))) + 
         geom_bar() + 
         labs(x = "Malaria Detected", y = "Count")

6. **Partition the Dataset**
   The data is split into training and testing subsets to allow for model evaluation.

   .. code-block:: r

      set.seed(123)  # Ensures reproducibility of the partition.
      trainIndex <- createDataPartition(mdata$severe_maleria, p = 0.75, list = FALSE)
      train <- mdata[trainIndex, ]  # Training set (75% of the data).
      test <- mdata[-trainIndex, ]  # Testing set (25% of the data).

      dim(train)  # Displays the dimensions of the training set.
      dim(test)   # Displays the dimensions of the testing set.

      # Convert the target variable in both subsets to a factor
      train$severe_maleria <- as.factor(train$severe_maleria)
      test$severe_maleria <- as.factor(test$severe_maleria)

7. **Define the Hyperparameter Grid**
   A grid of hyperparameter values is created for tuning the decision tree model.

   .. code-block:: r

      tuneGrid_dt <- expand.grid(cp = seq(0.01, 0.1, by = 0.01))
      # `cp` is the complexity parameter for the decision tree.

8. **Set Up Cross-Validation**
   Cross-validation is configured to ensure robust model evaluation.

   .. code-block:: r

      control <- trainControl(method = "cv", number = 10)
      # 10-fold cross-validation is used.

9. **Train the Decision Tree Model**
   The decision tree model is trained using the training dataset and the defined hyperparameter grid.

   .. code-block:: r

      set.seed(123)  # Ensures reproducibility.
      dtModel <- train(severe_maleria ~ ., 
                       data = train, 
                       method = "rpart", 
                       trControl = control,
                       tuneGrid = tuneGrid_dt)

      print(dtModel)  # Displays details of the trained model, including accuracy for different `cp` values.

10. **Visualize Model Performance**
    The performance of the model across different hyperparameter values is visualized.

    .. code-block:: r

       plot(dtModel)  # Plots accuracy vs. complexity parameter (cp).

11. **Make Predictions**
    The trained model is used to make predictions on the testing dataset.

    .. code-block:: r

       predictions <- predict(dtModel, newdata = test)

12. **Evaluate Model Performance**
    The performance of the model is evaluated using a confusion matrix.

    .. code-block:: r

       confMatrix <- confusionMatrix(predictions, test$severe_maleria)
       print(confMatrix)  # Displays metrics such as accuracy, sensitivity, and specificity.

13. **Visualize the Decision Tree**
    The final decision tree model is visualized.

    .. code-block:: r

       rpart.plot(dtModel$finalModel)  # Plots the decision tree structure.

---

### Explanation of Key Metrics

- **Accuracy**: Measures the proportion of correctly classified instances.
- **Sensitivity (Recall)**: Measures the proportion of actual positives correctly identified.
- **Specificity**: Measures the proportion of actual negatives correctly identified.

---

This stepwise documentation explains each step in the R script, making it easy to understand the workflow from data loading to model evaluation. Let me know if you'd like to add further sections or refine this!
