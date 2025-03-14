# author: DSCI 310 Group 3
# date: 2025-03-14

# Load necessary libraries
library(docopt)
library(httr)

# Define the command-line interface
doc <- " Usage: download_data.R --url=<url> --output=<output_file>
Options:
  --url=<url>           URL of the dataset to download
  --output=<output_file>  Path to save the downloaded dataset
"
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

# Run the main function with provided arguments
download_data(opt$url, opt$output)
