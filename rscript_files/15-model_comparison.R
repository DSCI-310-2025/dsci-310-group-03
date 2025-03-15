# author: DSCI 310 Group 3
# date: 2025-03-14

"This script compares confusion matrices and accuracies of the baseline, 
logistic regression, and random forest models.

Usage:
  15-model_comparison.R --input_csv=<input_csv> --input_img=<input_img> --output_csv=<output_csv> --output_img=<output_img>

Options:
  --input_csv=<input_csv>  Directory containing confusion matrix CSV files.
  --input_img=<input_img>  Directory containing confusion matrix PNG files.
  --output_csv=<output_csv> Path to save the accuracy comparison CSV file.
  --output_img=<output_img> Path to save the accuracy bar plot PNG file.
" -> doc

library(tidyverse)
library(gridExtra)
library(ggplot2)
library(grid)
library(docopt)
library(png)

opt <- docopt(doc)

main <- function(input_csv, input_img, output_csv, output_img) {
  
  base_table <- read_csv(file.path(input_csv, "baseline_conf_matrix.csv"), show_col_types = FALSE)
  mlr_table <- read_csv(file.path(input_csv, "mlr_conf_matrix.csv"), show_col_types = FALSE)
  rf_table <- read_csv(file.path(input_csv, "rf_conf_matrix.csv"), show_col_types = FALSE)


  base_img <- png::readPNG(file.path(input_img, "baseline_conf_matrix.png"))
  mlr_img <- png::readPNG(file.path(input_img, "mlr_conf_matrix.png"))
  rf_img <- png::readPNG(file.path(input_img, "rf_conf_matrix.png"))


  comparison_plot <- grid.arrange(
    rasterGrob(base_img), rasterGrob(mlr_img), rasterGrob(rf_img), 
    nrow = 1,
    top = textGrob("Model Confusion Matrix Comparison", gp = gpar(fontsize = 15, font = 2))
  )

  ggsave(file.path(output_img, "conf_matrix_comparison.png"), comparison_plot, width = 16, height = 4.5, dpi = 300)


  accuracy_table <- read_csv(file.path(input_csv, "model_accuracies.csv"), show_col_types = FALSE)


  accuracy_table$Accuracy <- accuracy_table$Accuracy * 100


  write_csv(accuracy_table, file.path(output_csv, "accuracy_comparison.csv"))


  accuracy_plot <- ggplot(accuracy_table, aes(x = Model, y = Accuracy, fill = Model)) +
    geom_bar(stat = "identity") +  
    geom_text(aes(label = round(Accuracy, 2)), vjust = -0.2, size = 5) +
    labs(title = "Model Accuracy Comparison", x = "Model Type", y = "Accuracy (%)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          plot.title = element_text(face = "bold")) 


  ggsave(file.path(output_img, "accuracy_comparison.png"), accuracy_plot, width = 9, height = 6, dpi = 300)
}

main(opt$input_csv, opt$input_img, opt$output_csv, opt$output_img)