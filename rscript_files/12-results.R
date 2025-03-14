# author: DSCI 310 Group 3
# date: 2025-03-13

# author: DSCI 310 Group 3
# date: 2025-03-13

"This script computes confusion matrices for baseline, logistic regression, and random forest models, 
saves the results as CSV files, and generates visualization plots.

Usage:
  12-results.R --test=<test_file> --base_preds=<base_preds> --lr_preds=<lr_preds> --rf_preds=<rf_preds> --output=<output_dir>

Options:
  --test=<test_file>      Path to the test dataset (CSV).
  --base_preds=<base_preds>   Path to baseline model predictions (CSV).
  --lr_preds=<lr_preds>   Path to logistic regression predictions (CSV).
  --rf_preds=<rf_preds>   Path to random forest predictions (CSV).
  --output=<output_dir>   Directory to save confusion matrices, accuracy results, and plots.
" -> doc

# Load necessary libraries
library(docopt)
library(tidyverse)
library(caret)   # For confusionMatrix
library(ggplot2)

opt <- docopt(doc)

# Function to compute confusion matrix and generate visualization
compute_conf_matrix <- function(true_labels, predicted_labels, model_name, output_dir, color_high) {
  conf_matrix <- confusionMatrix(as.factor(predicted_labels), as.factor(true_labels))
  conf_table <- as.data.frame(conf_matrix$table)
  colnames(conf_table) <- c("True", "Predicted", "Frequency")

  # Compute percentages
  conf_table <- conf_table %>%
    group_by(True) %>%
    mutate(Percentage = ifelse(sum(Frequency) == 0, 0, round((Frequency / sum(Frequency)) * 100, 1)))

  # Save confusion matrix as CSV
  write_csv(conf_table, file.path(output_dir, paste0(model_name, "_conf_matrix.csv")))

  # Generate and save visualization
  plot <- ggplot(conf_table, aes(x = True, y = Predicted, fill = Frequency)) +
    geom_tile(color = "black") +  
    geom_text(aes(label = paste0(Frequency, "\n(", Percentage, "%)")), color = "black", size = 6) +  
    scale_fill_gradient(low = "white", high = color_high) +  
    labs(title = paste(model_name, "Confusion Matrix"), x = "True Label", y = "Predicted Label") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))

  # Save plot as PNG
  ggsave(file.path(output_dir, paste0(model_name, "_conf_matrix.png")), plot, width = 7, height = 6, dpi = 300)

  return(conf_matrix)
}

main <- function(test_file, base_preds, lr_preds, rf_preds, output_dir) {
  # Load test data and predictions
  test_data <- read_csv(test_file, show_col_types = FALSE)
  base_predictions <- read_csv(base_preds, show_col_types = FALSE)$Predicted_Class
  lr_predictions <- read_csv(lr_preds, show_col_types = FALSE)$Predicted_Class
  rf_predictions <- read_csv(rf_preds, show_col_types = FALSE)$Predicted_Class

  # Ensure output directory exists
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

  # Compute confusion matrices
  base_conf_matrix <- compute_conf_matrix(test_data$RiskLevel, base_predictions, "Baseline", output_dir, "red")
  lr_conf_matrix <- compute_conf_matrix(test_data$RiskLevel, lr_predictions, "Logistic_Regression", output_dir, "green")
  rf_conf_matrix <- compute_conf_matrix(test_data$RiskLevel, rf_predictions, "Random_Forest", output_dir, "blue")

  # Compute accuracy for each model
  accuracy_table <- data.frame(
    Model = c("Baseline", "Logistic Regression", "Random Forest"),
    Accuracy = c(base_conf_matrix$overall["Accuracy"], 
                 lr_conf_matrix$overall["Accuracy"], 
                 rf_conf_matrix$overall["Accuracy"])
  )

  # Convert accuracy to percentage
  accuracy_table$Accuracy <- accuracy_table$Accuracy * 100

  # Save accuracy table as CSV
  write_csv(accuracy_table, file.path(output_dir, "accuracy_results.csv"))

  # Generate accuracy comparison plot
  accuracy_plot <- ggplot(accuracy_table, aes(x = Model, y = Accuracy, fill = Model)) +
    geom_bar(stat = "identity") +  
    geom_text(aes(label = round(Accuracy, 2)), vjust = -0.2, size = 5) +
    labs(title = "Figure 6: Model Accuracy Comparison", x = "Model Type", y = "Accuracy (%)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          plot.title = element_text(face = "bold"))

  # Save accuracy plot as PNG
  ggsave(file.path(output_dir, "accuracy_comparison.png"), accuracy_plot, width = 9, height = 6, dpi = 300)
}

# Run the script
main(opt$test, opt$base_preds, opt$lr_preds, opt$rf_preds, opt$output)