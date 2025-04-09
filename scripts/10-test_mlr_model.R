# author: DSCI 310 Group 3
# date: 2025-03-14

"This script loads a trained multinomial logistic regression model 
and evaluates it on a test dataset by predicting class labels 
and probabilities.

Usage:
  10-test_mlr_model.R --test=<test_file> --model=<model_file> --output=<output_dir>

Options:
  --test=<test_file>      Path to the test dataset (CSV).
  --model=<model_file>    Path to the trained model (.rds).
  --output=<output_dir>   Directory to save the predictions and probabilities.
" -> doc

library(readr)
library(tibble)
library(dplyr)
library(nnet)
library(caret)
library(broom)
library(docopt)
library(maternalhealthtools)

opt <- docopt(doc)

mlr_model_test <- function(test_file, model_file, output_dir) {
  
  test_data <- read_csv(test_file, show_col_types = FALSE)

  #multinom_model <- readRDS(model_file)

  #test_predictions <- predict(multinom_model, newdata = test_data)

  # test_probabilities <- predict(multinom_model, newdata = test_data, type = "probs")

  # Get predictions and class probabilities from the model
  test_results <- testing(model_file, test_data, return_probs = TRUE)
  test_predictions <- test_results$predictions
  test_probabilities <- test_results$probabilities
  
  # Create a dataframe combining probabilities with predicted class and ID
  test_probabilities_df <- as_tibble(test_probabilities) %>% 
    mutate(Predicted_Class = test_predictions, ID = 1:nrow(test_data)) %>% 
    relocate(ID, Predicted_Class)

  write_csv(test_probabilities_df, file.path(output_dir, "mlr_test_probabilities.csv"))

  mlr_accuracy <- mean(test_predictions == test_data$RiskLevel)
  message("MLR Model Accuracy: ", round(mlr_accuracy, 7))

  accuracy_df <- data.frame(Model = "Multinomial Logistic Regression", Accuracy = round(mlr_accuracy, 7))

  accuracy_file <- file.path(output_dir, "model_accuracies.csv")
  
  if (!file.exists(accuracy_file)) {
      write_csv(accuracy_df, accuracy_file)
  } else {
      write_csv(accuracy_df, accuracy_file, append = TRUE)
  }

}

mlr_model_test(opt$test, opt$model, opt$output)
