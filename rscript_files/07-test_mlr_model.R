# author: DSCI 310 Group 3
# date: 2025-03-13

"This script loads a trained multinomial logistic regression model 
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
library(docopt)

opt <- docopt(doc)

main <- function(test_file, model_file, output_dir) {
  test_data <- read_csv(test_file)

  multinom_model <- readRDS(model_file)

  test_predictions <- predict(multinom_model, newdata = test_data)

  test_probabilities <- predict(multinom_model, newdata = test_data, type = "probs")

  test_probabilities_df <- as_tibble(test_probabilities) %>% 
    mutate(ID = 1:nrow(test_data)) %>% 
    relocate(ID)

  write_csv(test_probabilities_df, file.path(output_dir, "test_probabilities.csv"))

}

main(opt$test, opt$model, opt$output)