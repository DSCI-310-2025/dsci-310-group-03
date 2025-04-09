# author: DSCI 310 Group 3
# date: 2025-03-14

"This script loads a trained random forest model 
and evaluates it on a test dataset by predicting class labels 
and probabilities.

Usage:
  13-test_rf_model.R --test=<test_file> --model=<model_file> --output=<output_dir>

Options:
  --test=<test_file>      Path to the test dataset (CSV).
  --model=<model_file>    Path to the trained model (.rds).
  --output=<output_dir>   Directory to save the predictions and probabilities.
" -> doc

library(readr)
library(dplyr)
library(tibble)
library(randomForest)
library(docopt)
library(maternalhealthtools)

opt <- docopt(doc)

test_rf_model <- function(test_file, model_file, output_dir) {
  test_data <- read_csv(test_file, show_col_types = FALSE)

  # Generate predictions using the saved Random Forest model
  rf_predictions <- testing(model_file, test_data)

  # Calculate prediction accuracy
  rf_accuracy <- mean(rf_predictions == test_data$RiskLevel)

  message("Random Forest Model Accuracy: ", round(rf_accuracy, 7))

  predictions_df <- tibble(ID = 1:nrow(test_data), Predicted_Class = rf_predictions)

  write_csv(predictions_df, file.path(output_dir, "rf_predictions.csv"))

  accuracy_df <- data.frame(Model = "Random Forest", Accuracy = round(rf_accuracy, 7))

  accuracy_file <- file.path(output_dir, "model_accuracies.csv")

  if (!file.exists(accuracy_file)) {
      write_csv(accuracy_df, accuracy_file)
  } else {
      write_csv(accuracy_df, accuracy_file, append = TRUE)
  }
}

test_rf_model(opt$test, opt$model, opt$output)
