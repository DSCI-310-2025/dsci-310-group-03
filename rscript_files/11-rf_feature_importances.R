# author: DSCI 310 Group 3
# date: 2025-03-13

"This script generates a Random Forest feature importance plot.

Usage:
  11-rf_feature_importances.R --model=<model_file> --output=<output_file>

Options:
  --model=<model_file>    Path to the trained Random Forest model RDS file.
  --output=<output_file>  Path to save the feature importance plot.
" -> doc

library(tidyverse)
library(randomForest)
library(vip)  
library(docopt)

opt <- docopt(doc)

rf_feature_importances <- function(model_file, output_file) {
    rf_model <- readRDS(model_file)

    feature_importance_plot <- vip(rf_model) +
        labs(title = 'Random Forest Feature Importance', 
             x = "Feature", y = "Importance") +
        theme_minimal() +  
        theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

    output <- file.path(output_file, "rf_feature_importance.png")

    ggsave(output, feature_importance_plot, width = 8, height = 6, dpi = 300)

}

rf_feature_importances(opt$model, opt$output)