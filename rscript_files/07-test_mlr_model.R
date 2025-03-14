# author: DSCI 310 Group 3
# date: 2025-03-14

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
library(broom)
library(docopt)

opt <- docopt(doc)

main <- function(test_file, model_file, output_dir) {
  test_data <- read_csv(test_file, show_col_types = FALSE)

  multinom_model <- readRDS(model_file)

  summary_df <- tidy(multinom_model, exp = FALSE) %>%
    rename(Term = term, Estimate = estimate, StdError = std.error, Statistic = statistic, PValue = p.value)
  write_csv(summary_df, output_dir)

  codds_ratios_df <- tidy(multinom_model, exp = TRUE) %>%
    rename(Term = term, OddsRatio = estimate, StdError = std.error, Statistic = statistic, PValue = p.value)
  write_csv(odds_ratios_df, output_dir)

  test_predictions <- predict(multinom_model, newdata = test_data)

  test_probabilities <- predict(multinom_model, newdata = test_data, type = "probs")

  test_probabilities_df <- as_tibble(test_probabilities) %>% 
    mutate(Predicted_Class = test_predictions, ID = 1:nrow(test_data)) %>% 
    relocate(ID, Predicted_Class)

  write_csv(test_probabilities_df, output_dir)
}

# Run the main function
main(opt$test, opt$model, opt$output)
