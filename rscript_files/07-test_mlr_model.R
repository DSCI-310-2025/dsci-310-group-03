# author: DSCI 310 Group 3
# date: 2025-03-14

"This script loads a trained multinomial logistic regression model 
and evaluates it on a test dataset by predicting class labels 
and probabilities.

Usage:
  07-test_mlr_model.R --test=<test_file> --model=<model_file> --output=<output_dir>

Options:
  --test=<test_file>      Path to the test dataset (CSV).
  --model=<model_file>    Path to the trained model (.rds).
  --output=<output_dir>   Directory to save the predictions and probabilities.
" -> doc

library(tidyverse)
library(nnet)
library(broom)
library(docopt)

opt <- docopt(doc)

mlr_model_test <- function(test_file, model_file, output_dir) {
  test_data <- read_csv(test_file, show_col_types = FALSE)

  multinom_model <- readRDS(model_file)

  summary_df <- tidy(multinom_model, exp = FALSE) %>%
    rename(Term = term, Estimate = estimate, StdError = std.error, Statistic = statistic, PValue = p.value)
  write_csv(summary_df, file.path(output_dir, "mlr_model_summary_test.csv"))


  odds_ratios_df <- tidy(multinom_model, exp = TRUE) %>%
    rename(Term = term, OddsRatio = estimate, StdError = std.error, Statistic = statistic, PValue = p.value)
  write_csv(odds_ratios_df, file.path(output_dir, "mlr_model_odds_ratios_test.csv"))

  test_predictions <- predict(multinom_model, newdata = test_data)

  test_probabilities <- predict(multinom_model, newdata = test_data, type = "probs")

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
