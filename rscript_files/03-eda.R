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

  cor_values <- cor_matrix %>%
    as.data.frame() %>%
    rownames_to_column("Feature_1") %>%
    pivot_longer(-Feature_1, names_to = "Feature_2", values_to = "Correlation") %>%
    filter(Feature_1 != Feature_2) %>%
    arrange(desc(abs(Correlation)))

  write_csv(cor_values, file.path(output_csv, "correlation_values.csv"))
  
  cor_plot_ellipses <- ggcorrplot(cor_matrix, 
                                  method = "ellipse", 
                                  type = "upper", 
                                  colors = c("red", "white", "blue"))

  ggsave(file.path(output, "correlation_matrix.png"), plot = cor_plot_ellipses, width = 8, height =6)

  cor_plot_numbers <- ggcorrplot(cor_matrix, 
                                method = "square", 
                                type = "upper", 
                                lab = TRUE,
                                lab_size = 4)

  ggsave(file.path(output, "correlation_values.png"), plot = cor_plot_numbers, width = 8, height = 6)
}

eda(opt$input, opt$output_img, opt$output_csv)