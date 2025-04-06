# author: DSCI 310 Group 3
# date: 2025-03-14

library(docopt)

"This script downloads and extracts the dataset from a predefined URL.

Usage: 
  01-load_data.R --output=<output_dir>
  
Options:
  --output=<output_dir>   Directory to save the extracted dataset
" -> doc

opt <- docopt(doc)

download_and_extract <- function(output_dir) {
  url <- "https://archive.ics.uci.edu/static/public/863/maternal+health+risk.zip"
  zip_path <- file.path(output_dir, "maternal_health_risk.zip")
  csv_output_path <- file.path(output_dir, "maternal_health_risk_data.csv")

  download.file(url, zip_path, mode = "wb")
  unzip(zip_path, exdir = output_dir)

  extracted_csv <- list.files(output_dir, pattern = "\\.csv$", full.names = TRUE)[1]
  file.rename(extracted_csv, csv_output_path)
}

download_and_extract(opt$output)