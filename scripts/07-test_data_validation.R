library(pointblank)
library(readr)
library(dplyr)

"This script performs data validation checks on the test dataset.

Usage:
  Rscript scripts/07-test_data_validation.R
"

test_tbl <- file_tbl('data/processed/test_data.csv')
clean_tbl <- file_tbl('data/processed/cleaned_data.csv')

total_count <- nrow(clean_tbl)

test_agent <- test_tbl %>%
    create_agent() %>%

    #Checks for correct data file format (i.e., correct split)
    col_vals_expr(expr(abs(nrow(.) / !!total_count - 0.2) < 0.01))%>%
    
    interrogate()

print(test_agent)

export_report(test_agent, filename = "test_agent.html", path = 'outputs/agents/')

if (!all_passed(test_agent)) {
  stop("Test data validation failed. Please check the report by running 'browseURL('outputs/agents/test_agent.html')' in the console.")
}