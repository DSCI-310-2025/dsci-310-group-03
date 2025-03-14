# author: DSCI 310 Group 3
# date: 2025-03-13

"This script performs EDA and generates visualizations.

Usage:
  03-eda.R --input=<input_file> --output=<output_dir>
  
Options:
  --input=<input_file>    Path to cleaned data CSV file
  --output=<output_dir>   Directory to save output figures
" -> doc

library(tidyverse)
library(ggplot2)
library(docopt)
library(corrplot)

opt <- docopt(doc)

main <- function(input, output) {
  data_clean <- read_csv(input)

  # Summary
  summary <- summary(data_clean)

  write_csv(summary, output)

  # Boxplot of Age by Risk Level
  bp <- ggplot(data_clean, aes(x = RiskLevel, y = Age, fill = RiskLevel)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "Age Distribution by Risk Level", x = "Risk Level", y = "Age")

  ggsave(filename = file.path(output, "age_distribution.png"), plot = bp, width = 8, height = 6)


  data_numeric <- data_clean %>%
    mutate(RiskLevel_numeric = as.numeric(RiskLevel)) %>%
    select(-RiskLevel)

  cor_matrix <- cor(data_numeric)

  options(repr.plot.width=6.5, repr.plot.height=6)

  png(filename = file.path(output, "correlation_matrix.png"), width = 800, height = 600)
  corrplot(cor_matrix, method = "ellipse", type = "upper", tl.cex = 0.8, tl.col = "black",
            col = colorRampPalette(c("red", "grey", "blue"))(200))
  mtext("Figure 2b: Correlation Matrix", side = 3, line = 3, cex = 1.5, font = 2)
  dev.off()

  png(filename = file.path(output, "correlation_values.png"), width = 800, height = 600)
  corrplot(cor_matrix, method = "number", type = "upper", number.cex = 1.5, tl.cex = 0.8, tl.col = "black",
            col = colorRampPalette(c("red", "grey", "blue"))(200))
  mtext("Figure 2b: Correlation Matrix Values", side = 3, line = 3, cex = 1.5, font = 2)
  dev.off()
}

main(opt$input, opt$output)