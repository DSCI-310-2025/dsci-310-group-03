# author: DSCI 310 Group 3
# date: 2025-03-13

"This script generates a GAM-smoothed plot of predicted probabilities
across blood sugar levels using a trained multinomial logistic regression model.

Usage:
  11-graph_mlr.R --test=<test_file> --model=<model_file> --output_plot=<output_plot>

Options:
  --test=<test_file>        Path to the test dataset (CSV)
  --model=<model_file>      Path to the trained model RDS file
  --output_plot=<output_plot>  Path to save the plot (e.g., images/blood_sugar_plot.png)
" -> doc

library(readr)
library(tidyr)
library(ggplot2)
library(vip)
library(mgcv)
library(nnet)
library(docopt)
library(maternalhealthtools)

opt <- docopt(doc)

graph_blood_sugar <- function(test_file, model_file, output_plot) {

    set.seed(123)


    test_data <- read_csv(test_file)
    multinom_model <- readRDS(model_file)

    # Predict class probabilities for each test observation
    pred_probs <- predict(multinom_model, newdata = test_data, type = "probs")
    prob_data <- as.data.frame(pred_probs)

    # Add the Blood Sugar (BS) values from the test data for plotting
    prob_data$BS <- test_data$BS  


    prob_long <- pivot_longer(prob_data, cols = c("low risk", "mid risk", "high risk"), 
                              names_to = "RiskLevel", values_to = "Probability")

    # Use visualization.R function to create predicted probabilities plot
    plot_pred_prob(prob_long, 'outputs/images')    
}

graph_blood_sugar(opt$test, opt$model, opt$output_plot)