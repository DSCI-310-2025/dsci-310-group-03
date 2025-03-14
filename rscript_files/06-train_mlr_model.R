# author: DSCI 310 Group 3
# date: 2025-03-13

"This script trains a multinomial logistic regression model 
and saves the model summary and exponentiated coefficients.

Usage:
  train_model.R --train=<train_file> --output=<output_file> --summary=<summary_file>

Options:
  --train=<train_file>     Path to the training dataset (CSV).
  --output=<output_file>   Path to save the trained model (.rds).
  --summary=<summary_file> Path to save model summary and coefficients (CSV).
" -> doc

library(tidyverse)
library(nnet)
library(docopt)
library(broom)

opt <- docopt(doc)

main <- function(train_file, output_file, summary_file) {
  train_data <- read_csv(train_file)


  multinom_model <- multinom(RiskLevel ~ ., data = train_data)

  saveRDS(multinom_model, output_file)


  model_summary <- tidy(multinom_model)

  model_summary <- model_summary %>%
    mutate(odds_ratio = exp(estimate))

  write_csv(model_summary, summary_file)

}

main(opt$train, opt$output, opt$summary)