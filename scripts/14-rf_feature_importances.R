# author: DSCI 310 Group 3
# date: 2025-03-13

"This script generates a Random Forest feature importance plot.

Usage:
  14-rf_feature_importances.R --model=<model_file> --output=<output_file>

Options:
  --model=<model_file>    Path to the trained Random Forest model RDS file.
  --output=<output_file>  Path to save the feature importance plot.
" -> doc

library(readr)
library(tidyr)
library(ggplot2)
library(mgcv)
library(nnet)
library(randomForest)
library(vip)
library(docopt)
source("R/visualization.R")

opt <- docopt(doc)

rf_feature_importances <- function(model_file, output_file) {
    rf_model <- readRDS(model_file)

    # Use visualization.R function to create feature importances plot
    visualization("feature_importance", rf_model, NULL, "outputs/images")

}

rf_feature_importances(opt$model, opt$output)