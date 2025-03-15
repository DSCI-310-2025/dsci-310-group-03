# author: DSCI 310 Group 3
# date: 2025-03-14

library(docopt)
library(httr)

"This script retrieves the dataset from the url.

Usage: 
  01-load_data.R --url=<url> --output=<output_file>
  
Options:
  --url=<url>           URL of the dataset to download
  --output=<output_file>  Path to save the downloaded dataset
" -> doc

opt <- docopt(doc)

download_data <- function(url, output_file) {
  response <- httr::GET(url)
  
  if (httr::status_code(response) == 200) {
    data_text <- httr::content(response, as = "text", encoding = "UTF-8")
    
    data <- read_csv(data_text, show_col_types = FALSE)
    
    write_csv(data, output_file)
    
    message("Dataset downloaded and saved successfully to: ", output_file)
  } else {
    stop("Failed to download the dataset. HTTP status code: ", httr::status_code(response))
  }
}

download_data(opt$url, opt$output)
