# author: DSCI 310 Group 3
# date: 2025-03-13

"This script generates a GAM-smoothed plot of predicted probabilities
across blood sugar levels using a trained multinomial logistic regression model.

Usage:
  08-graph_mlr.R --test=<test_file> --model=<model_file> --output_plot=<output_plot>

Options:
  --test=<test_file>        Path to the test dataset (CSV)
  --model=<model_file>      Path to the trained model RDS file
  --output_plot=<output_plot>  Path to save the plot (e.g., results/blood_sugar_plot.png)
" -> doc

library(tidyverse)
library(nnet)
library(mgcv)  
library(docopt)

opt <- docopt(doc)

main <- function(test_file, model_file, output_plot) {

    set.seed(123)


    test_data <- read_csv(test_file)
    multinom_model <- readRDS(model_file)


    pred_probs <- predict(multinom_model, newdata = test_data, type = "probs")
    prob_data <- as.data.frame(pred_probs)

    prob_data$BS <- test_data$BS  


    prob_long <- pivot_longer(prob_data, cols = c("low risk", "mid risk", "high risk"), 
                              names_to = "RiskLevel", values_to = "Probability")


    blood_sugar_plot <- ggplot(prob_long, aes(x = BS, y = Probability, color = RiskLevel)) +
        geom_smooth(method = "gam", formula = y ~ s(x, bs = 'cs'), se = FALSE, size = 1) +  
        theme_minimal() +
        labs(title = "Figure 4: Predicted Probabilities Across Blood Sugar Levels",
             x = "Blood Sugar (BS)",
             y = "Predicted Probability") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))


    ggsave(output_plot, plot = blood_sugar_plot, width = 8, height = 6, dpi = 300)
}

main(opt$test, opt$model, opt$output_plot)