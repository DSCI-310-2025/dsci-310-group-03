# author: DSCI 310 Group 3
# date: 2025-03-13

"This script computes the baseline accuracy for a classification model 
by predicting the most frequent class in the training data.

Usage:
  08-baseline_model.R --train=<train_file> --test=<test_file> --output=<output_dir>

Options:
  --train=<train_file>    Path to the training dataset (CSV).
  --test=<test_file>      Path to the testing dataset (CSV).
  --output=<output_dir>   Directory to save predictions and accuracy files.
" -> doc

library(readr)
library(tibble)
library(dplyr)
library(docopt)

opt <- docopt(doc)

test_baseline_model <- function(train_file, test_file, output_dir) {
  train_data <- read_csv(train_file, show_col_types = FALSE)
  test_data <- read_csv(test_file, show_col_types = FALSE)


  majority_class <- names(sort(table(train_data$RiskLevel), decreasing = TRUE))[1]


  majority_predictions <- factor(rep(majority_class, nrow(test_data)), 
                                 levels = levels(as.factor(test_data$RiskLevel)))


  majority_accuracy <- mean(majority_predictions == test_data$RiskLevel)
  message("Majority Class Baseline Accuracy: ", round(majority_accuracy, 7))


  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  predictions_file <- file.path(output_dir, "baseline_predictions.csv")
  predictions_df <- tibble(ID = 1:nrow(test_data), Predicted_Class = majority_predictions)
  write_csv(predictions_df, predictions_file)

  accuracy_df <- data.frame(Model = "Baseline", Accuracy = round(majority_accuracy, 7))
  accuracy_file <- file.path(output_dir, "model_accuracies.csv")

  if (!file.exists(accuracy_file)) {
      write_csv(accuracy_df, accuracy_file)
  } else {
      existing_data <- read_csv(accuracy_file, show_col_types = FALSE)
      combined_data <- bind_rows(existing_data, accuracy_df)
      write_csv(combined_data, accuracy_file)
  }
  
}

test_baseline_model(opt$train, opt$test, opt$output)