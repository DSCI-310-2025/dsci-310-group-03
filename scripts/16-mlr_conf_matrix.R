# author: DSCI 310 Group 3
# date: 2025-03-14

"This script generates a confusion matrix for the multinomial logistic regression model 
and saves the results as a CSV and PNG file.

Usage:
  16-mlr_conf_matrix.R --test=<test_file> --predictions=<pred_file> --output_csv=<output_csv> --output_img=<output_img>

Options:
  --test=<test_file>        Path to the test dataset (CSV).
  --predictions=<pred_file> Path to the saved MLR predictions (CSV).
  --output_csv=<output_csv> Path to save the confusion matrix CSV file.
  --output_img=<output_img> Path to save the confusion matrix PNG file.
" -> doc

library(readr)
library(tidyr)
library(dplyr)
library(vip)
library(mgcv)
library(nnet)
library(caret)
library(ggplot2)
library(docopt)
source("R/visualization.R")

opt <- docopt(doc)

multi_lin_reg_conf_matrix <- function(test_file, pred_file, output_csv, output_img) {
  test_data <- read_csv(test_file, show_col_types = FALSE)
  pred_data <- read_csv(pred_file, show_col_types = FALSE)

  mlr_conf_matrix <- confusionMatrix(as.factor(pred_data$Predicted_Class), as.factor(test_data$RiskLevel))

  mlr_table <- as.data.frame(mlr_conf_matrix$table)
  colnames(mlr_table) <- c("True", "Predicted", "Frequency")

  mlr_table <- mlr_table %>%
    mutate(True = factor(True, levels = c("low risk", "mid risk", "high risk")),
    Predicted = factor(Predicted, levels = c("low risk", "mid risk", "high risk"))) %>%
    group_by(True) %>%
    mutate(Percentage = ifelse(is.na(Frequency), 0, round((Frequency / sum(Frequency)) * 100, 1)))


  write_csv(mlr_table, file.path(output_csv, "mlr_conf_matrix.csv"))


  visualization("conf_matrix", mlr_table, "mlr", "outputs/images")
}

multi_lin_reg_conf_matrix(opt$test, opt$predictions, opt$output_csv, opt$output_img)