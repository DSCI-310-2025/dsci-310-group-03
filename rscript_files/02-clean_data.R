# author: DSCI 310 Group 3
# date: 2025-03-13

"This script loads and cleans the dataset.

Usage:
  02-clean_data.R --input=<input_file> --output=<output_file>

Options:
  --input=<input_file>    Path to raw data CSV file
  --output=<output_file>   Path to save cleaned data CSV file
" -> doc

library(tidyverse)
library(docopt)

opt <- docopt(doc)

clean_data <- function(input, output) {
  data <- read_csv(input)

  data_clean <- data %>%
    mutate(RiskLevel = as.factor(RiskLevel)) %>% 
    drop_na()

  write_csv(data_clean, file.path(output, "cleaned_data.csv"))

  data_nan <- tibble(feature = names(data), na = colSums(is.na(data)))

  write_csv(data_nan, file.path(output, "nan_data.csv"))

  data_target_classes <- data %>% distinct(RiskLevel)

  write_csv(data_target_classes, file.path(output, "target_classes.csv"))
}

clean_data(opt$input, opt$output)