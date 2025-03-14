# author: DSCI 310 Group 3
# date: 2025-03-14

"This script loads a trained random forest model 
and evaluates it on a test dataset by predicting class labels 
and probabilities.

Usage:
  test_model.R --test=<test_file> --model=<model_file> --output=<output_dir>

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

main <- function(test_file, model_file, output_dir) {
  test_data <- read_csv(test_file, show_col_types = FALSE)

  rf_model <- readRDS(model_file)

  rf_predictions <- predict(rf_model, test_data)

  output_file <- file.path(output_dir, "rf_predictions.csv")
  write_csv(predictions_df, output_file)
}

# Run the main function
main(opt$test, opt$model, opt$output)
