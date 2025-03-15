# author: DSCI 310 Group 3
# date: 2025-03-13

"This script computes the baseline accuracy for a classification model 
by predicting the most frequent class in the training data.

Usage:
  05-baseline_model.R --train=<train_file> --test=<test_file> --output=<output_file>

Options:
  --train=<train_file>    Path to the training dataset (CSV).
  --test=<test_file>      Path to the testing dataset (CSV).
  --output=<output_file>  Path to save the computed accuracy (CSV).
" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)

main <- function(train_file, test_file, output_file) {
  train_data <- read_csv(train_file, show_col_types = FALSE)
  test_data <- read_csv(test_file, show_col_types = FALSE)

  majority_class <- names(sort(table(train_data$RiskLevel), decreasing = TRUE))[1]

  majority_predictions <- factor(rep(majority_class, nrow(test_data)), 
                                 levels = levels(as.factor(test_data$RiskLevel)))

  majority_accuracy <- mean(majority_predictions == test_data$RiskLevel)

  message("Majority Class Baseline Accuracy: ", round(majority_accuracy, 7))

  accuracy_df <- data.frame(Model = "Baseline", Accuracy = round(majority_accuracy, 7))

  accuracy_file <- file.path(output_file, "model_accuracies.csv")

  if (!file.exists(output_file)) {
      write_csv(accuracy_df, output_file)
  } else {
      write_csv(accuracy_df, output_file, append = TRUE)
  }

}

main(opt$train, opt$test, opt$output)
