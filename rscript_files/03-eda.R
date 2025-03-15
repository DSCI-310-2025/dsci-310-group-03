# author: DSCI 310 Group 3
# date: 2025-03-13

"This script performs EDA and generates visualizations.

Usage:
  03-eda.R --input=<input_file> --output_img=<output_img_dir> --output_csv=<output_csv_dir>
  
Options:
  --input=<input_file>    Path to cleaned data CSV file
  --output_img=<output_img_dir>  Directory to save output figures
  --output_csv=<output_csv_dir>  Directory to save summary CSV
" -> doc

library(tidyverse)
library(ggplot2)
library(docopt)
library(corrplot)

opt <- docopt(doc)

eda <- function(input, output_img, output_csv) {
  data_clean <- read_csv(input)


  summary_df <- data_clean %>% 
    summarise(across(where(is.numeric), list(
      min = min, max = max, mean = mean, median = median, sd = sd
    ), na.rm = TRUE)) %>%
    pivot_longer(everything(), names_to = c("Feature", ".value"), names_sep = "_")

  write_csv(summary_df, file.path(output_csv, "eda_summary.csv"))

  # Boxplot of Age by Risk Level
  bp <- ggplot(data_clean, aes(x = RiskLevel, y = Age, fill = RiskLevel)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "Age Distribution by Risk Level", x = "Risk Level", y = "Age")

  ggsave(filename = file.path(output_img, "age_distribution.png"), plot = bp, width = 8, height = 6)


  data_numeric <- data_clean %>%
    mutate(RiskLevel_numeric = as.numeric(RiskLevel)) %>%
    select(-RiskLevel)

  cor_matrix <- cor(data_numeric)

  "
  options(repr.plot.width=6.5, repr.plot.height=6)

  png(filename = file.path(output_img, "correlation_matrix.png"), width = 800, height = 600)
  corrplot(cor_matrix, method = "ellipse", type = "upper", tl.cex = 0.8, tl.col = "black",
            col = colorRampPalette(c("red", "grey", "blue"))(200))
  dev.off()

  png(filename = file.path(output_img, "correlation_values.png"), width = 800, height = 600)
  corrplot(cor_matrix, method = "number", type = "upper", number.cex = 1.5, tl.cex = 0.8, tl.col = "black",
            col = colorRampPalette(c("red", "grey", "blue"))(200))
  dev.off()
  "

    # Plot 1: Only ellipses
  cor_plot_ellipses <- ggcorrplot(cor_matrix, 
                                  method = "ellipse", 
                                  type = "upper", 
                                  colors = c("red", "white", "blue"))

  ggsave(file.path(output, "correlation_matrix.png"), plot = cor_plot_ellipses, width = 8, height = 6)

  # Plot 2: Only numbers
  cor_plot_numbers <- ggcorrplot(cor_matrix, 
                                method = "square", 
                                type = "upper", 
                                lab = TRUE,
                                lab_size = 4)

  ggsave(file.path(output, "correlation_values.png"), plot = cor_plot_numbers, width = 8, height = 6)
}

eda(opt$input, opt$output_img, opt$output_csv)