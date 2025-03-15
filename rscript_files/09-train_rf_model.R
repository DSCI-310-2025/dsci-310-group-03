# author: DSCI 310 Group 3
# date: 2025-03-13

"This script trains a Random Forest model on the given training dataset 
and saves the trained model as an RDS file.

Usage:
  09-train_rf_model.R --train=<train_file> --output=<model_file>

Options:
  --train=<train_file>   Path to the training dataset (CSV file).
  --output=<model_file>  Path to save the trained model as an RDS file.
" -> doc

library(docopt)
library(tidyverse)
library(randomForest)

opt <- docopt(doc)

train_rf_model <- function(train_file, model_file) {
  train_data <- read_csv(train_file, show_col_types = FALSE)
  
  rf_model <- randomForest(RiskLevel ~ ., data = train_data, ntree = 500, importance = TRUE)
  
  write_rds(rf_model, model_file)
}

train_rf_model(opt$train, opt$output)
