# author: DSCI 310 Group 3
# date: 2025-03-13

"This script trains a multinomial logistic regression model 
and saves the model summary and exponentiated coefficients.

Usage:
  09-train_mlr_model.R --train=<train_file> --output_model=<output_model_dir> --output_csv=<output_csv_dir>

Options:
  --train=<train_file>           Path to the training dataset (CSV).
  --output_model=<output_model_dir>  Directory to save the trained model.
  --output_csv=<output_csv_dir>  Directory to save model summary CSV.
" -> doc

library(readr)
library(dplyr)
library(docopt)
library(broom)
library(maternalhealthtools)

opt <- docopt(doc)

train_mlr_model <- function(train, output_model, output_csv) {
  train_data <- read_csv(train)
  # Format RiskLevel as a factor with a specified order and set "low risk" as the reference level
train_data <- train_data %>%
  mutate(RiskLevel = factor(RiskLevel, levels = c("low risk", "mid risk", "high risk"))) %>%
  mutate(RiskLevel = relevel(RiskLevel, ref = "low risk"))
  # Train the multinomial logistic regression model using custom training function
  multinom_model <- training_mlr_model(train_data)

  saveRDS(multinom_model, file.path(output_model, "mlr_model.rds"))

  model_summary <- tidy(multinom_model)
  write_csv(model_summary, file.path(output_csv, "mlr_model_summary.csv"))


  model_summary_odds_ratios <- multinom_model %>%
    tidy(exp = TRUE)

  write_csv(model_summary_odds_ratios, file.path(output_csv, "mlr_model_odds_ratios.csv"))
}

train_mlr_model(opt$train, opt$output_model, opt$output_csv)