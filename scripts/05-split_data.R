# author: DSCI 310 Group 3
# date: 2025-03-13

"This script loads the cleaned dataset, splits it into training and testing sets.
Then saves them into a specified output directory.

Usage:
  05-split_data.R --input=<input_file> --output=<output_dir>

Options:
  --input=<input_file>   Path to the cleaned dataset
  --output=<output_dir>  Directory to save train/test datasets
" -> doc

library(tidyverse)
library(caret)
library(docopt)

opt <- docopt(doc)

split_data <- function(input, output) {
    set.seed(123) 

    data_clean <- read_csv(input)

    train_index <- createDataPartition(data_clean$RiskLevel, p = 0.8, list = FALSE)
    train_data <- data_clean[train_index, ]
    test_data <- data_clean[-train_index, ]

    write_csv(train_data, file.path(output, "train_data.csv"))
    write_csv(test_data, file.path(output, "test_data.csv"))

}

split_data(opt$input, opt$output)