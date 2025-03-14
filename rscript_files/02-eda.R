# author: DSCI 310 Group 3
# date: 2025-03-13

"This script performs EDA and generates visualizations.

Usage:
  eda_visualization.R --input=<input_file> --output=<output_dir>

Options:
  --input=<input_file>    Path to cleaned data CSV file
  --output=<output_dir>   Directory to save output figures
" -> doc

library(tidyverse)
library(ggplot2)
library(docopt)

opt <- docopt(doc)

main <- function(input, output) {
  data_clean <- read_csv(input)

  # Boxplot of Age by Risk Level
  bp <- ggplot(data_clean, aes(x = RiskLevel, y = Age, fill = RiskLevel)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "Age Distribution by Risk Level", x = "Risk Level", y = "Age")

  ggsave(filename = file.path(output, "age_distribution.png"), plot = bp, width = 8, height = 6)
}

main(opt$input, opt$output)