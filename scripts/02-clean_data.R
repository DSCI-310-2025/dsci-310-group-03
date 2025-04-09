# author: DSCI 310 Group 3
# date: 2025-03-13

"This script loads and cleans the dataset.

Usage:
  02-clean_data.R --input=<input_file> --output=<output_file>

Options:
  --input=<input_file>    Path to raw data CSV file
  --output=<output_file>   Path to save cleaned data CSV file
" -> doc

library(readr)
library(docopt)
library(maternalhealthtools)

opt <- docopt(doc)

clean_data <- function(input, output) {
  data <- read_csv(input)

  data_clean <- clean(data, RiskLevel)

  write_csv(data_clean, file.path(output, "cleaned_data.csv"))

  data_nan <- check_na(data)

  write_csv(data_nan, file.path(output, "nan_data.csv"))

  data_target_classes <- get_targets(data, RiskLevel)

  write_csv(data_target_classes, file.path(output, "target_classes.csv"))
}

clean_data(opt$input, opt$output)