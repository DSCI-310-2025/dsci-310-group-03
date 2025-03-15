# author: DSCI 310 Group 3
# date: 2025-03-14

library(docopt)
library(httr)
library(readr)
library(zip)

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


  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }


  response <- httr::GET(url, write_disk(zip_path, overwrite = TRUE))

  if (httr::status_code(response) == 200) {
    message("Download successful: ", zip_path)
    

    unzip(zip_path, exdir = output_dir)
    

    extracted_files <- list.files(output_dir, pattern = "\\.csv$", full.names = TRUE)
    
    if (length(extracted_files) == 0) {
      stop("No CSV file found in the extracted zip.")
    }
    
    extracted_csv <- extracted_files[1]  
    

    file.rename(extracted_csv, csv_output_path)
    
    message("Extracted CSV renamed to: ", csv_output_path)
    
  } else {
    stop("Failed to download the dataset. HTTP status code: ", httr::status_code(response))
  }
}

download_and_extract(opt$output)