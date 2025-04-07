library(pointblank)
library(readr)
library(dplyr)

"This script performs data validation checks on the cleaned dataset.

Usage:
  Rscript scripts/03-clean_data_validation.R
"

clean_tbl <- file_tbl('data/processed/cleaned_data.csv')

cols <- c('Age', 'SystolicBP', 'DiastolicBP', 'BS', 'BodyTemp', 'HeartRate', 'RiskLevel')

cols_schema <- col_schema(
    Age = 'numeric',
    SystolicBP = 'numeric',
    DiastolicBP = 'numeric',
    BS = 'numeric',
    BodyTemp = 'numeric',
    HeartRate = 'numeric',
    RiskLevel = 'character'
)

clean_agent <- clean_tbl %>%
    create_agent() %>%

    #Checks for correct data file format

    #Checks for correct column names and correct data types in each column
    col_schema_match(schema = cols_schema) %>%

    #Checks for no missing observations
    col_vals_not_null(columns = cols) %>%
    rows_complete() %>%

    #Checks for no duplicate observations
    rows_distinct() %>%

    #Checks for no outlier or anomalous values
    col_vals_between(Age, left = 0, right = 100) %>%
    col_vals_between(SystolicBP, left = 60, right = 200) %>%
    col_vals_between(DiastolicBP, left = 40, right = 110) %>%
    col_vals_between(BS, left = 0, right = 20) %>%
    col_vals_between(BodyTemp, left = 95, right = 110) %>%
    col_vals_between(HeartRate, left = 0, right = 100) %>%

    #Checks correct category levels
    col_vals_in_set(RiskLevel, set = c("low risk", "mid risk", "high risk")) %>%

    interrogate() 

print(clean_agent)

export_report(clean_agent, filename = "clean_agent.html", path = 'outputs/agents/')

if (!all_passed(clean_agent)) {
  stop("Clean data validation failed. Please check the report by running 'browseURL('outputs/agents/clean_agent.html')' in the console.")
}