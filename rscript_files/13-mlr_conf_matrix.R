# author: DSCI 310 Group 3
# date: 2025-03-14

"This script generates a confusion matrix for the multinomial logistic regression model 
and saves the results as a CSV and PNG file.

Usage:
  13-mlr_conf_matrix.R --test=<test_file> --predictions=<pred_file> --output_csv=<output_csv> --output_img=<output_img>

Options:
  --test=<test_file>        Path to the test dataset (CSV).
  --predictions=<pred_file> Path to the saved MLR predictions (CSV).
  --output_csv=<output_csv> Path to save the confusion matrix CSV file.
  --output_img=<output_img> Path to save the confusion matrix PNG file.
" -> doc

library(tidyverse)
library(caret)
library(ggplot2)
library(docopt)

opt <- docopt(doc)

main <- function(test_file, pred_file, output_csv, output_img) {
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


  mlr_visualization <- ggplot(mlr_table, aes(x = True, y = Predicted, fill = Frequency)) +
    geom_tile(color = "black") +
    geom_text(aes(label = paste0(Frequency, "\n(", Percentage, "%)")), color = "black", size = 6) +
    scale_fill_gradient(low = "white", high = "green") +
    labs(title = "MLR Confusion Matrix", x = "True Label", y = "Predicted Label") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))


  ggsave(file.path(output_img, "mlr_conf_matrix.png"), mlr_visualization, width = 8, height = 6, dpi = 300)
}

main(opt$test, opt$predictions, opt$output_csv, opt$output_img)