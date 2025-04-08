# author: DSCI 310 Group 3
# date: 2025-03-14

"This script generates a confusion matrix for the random forest model 
and saves the results as a CSV and PNG file.

Usage:
  17-rf_conf_matrix.R --test=<test_file> --predictions=<pred_file> --output_csv=<output_csv> --output_img=<output_img>

Options:
  --test=<test_file>        Path to the test dataset (CSV).
  --predictions=<pred_file> Path to the saved RF predictions (CSV).
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

ran_for_conf_matrix <- function(test_file, pred_file, output_csv, output_img) {
  test_data <- read_csv(test_file, show_col_types = FALSE)
  pred_data <- read_csv(pred_file, show_col_types = FALSE)

  # Compute the confusion matrix comparing predicted vs. actual labels
  rf_conf_matrix <- confusionMatrix(as.factor(pred_data$Predicted_Class), as.factor(test_data$RiskLevel))

  # Convert the confusion matrix to a data frame for manipulation
  rf_table <- as.data.frame(rf_conf_matrix$table)
  colnames(rf_table) <- c("True", "Predicted", "Frequency")

  # Add factor levels and calculate percentage within each True class
  rf_table <- rf_table %>%
    mutate(True = factor(True, levels = c("low risk", "mid risk", "high risk")),
    Predicted = factor(Predicted, levels = c("low risk", "mid risk", "high risk"))) %>%
    group_by(True) %>%
    mutate(Percentage = ifelse(is.na(Frequency), 0, round((Frequency / sum(Frequency)) * 100, 1)))



  write_csv(rf_table, file.path(output_csv, "rf_conf_matrix.csv"))


  visualization("conf_matrix", rf_table, "rf", "outputs/images")
}

ran_for_conf_matrix(opt$test, opt$predictions, opt$output_csv, opt$output_img)