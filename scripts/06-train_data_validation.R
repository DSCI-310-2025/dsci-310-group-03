library(pointblank)
library(readr)
library(dplyr)

train_tbl <- file_tbl('data/processed/train_data.csv')
clean_tbl <- file_tbl('data/processed/cleaned_data.csv')

total_count <- nrow(clean_tbl)

train_agent <- train_tbl %>%
    create_agent() %>%

    #Checks for correct data file format (i.e., correct split)
    col_vals_expr(expr(abs(nrow(.) / !!total_count - 0.8) < 0.01))%>%

    #Checks for target/response variable follows expected distribution
    col_vals_expr(expr(abs(prop.table(table(.$RiskLevel))['high risk'] - 0.2479339) <= 0.1)) %>%
    col_vals_expr(expr(abs(prop.table(table(.$RiskLevel))['mid risk']  - 0.2341598) <= 0.1)) %>%
    col_vals_expr(expr(abs(prop.table(table(.$RiskLevel))['low risk']  - 0.5179063) <= 0.1)) %>%
    
    interrogate()

print(train_agent)

export_report(train_agent, filename = "train_agent.html", path = 'outputs/agents/')

if (!all_passed(train_agent)) {
  stop("Train data validation failed. Please check the report by running 'browseURL('outputs/agents/train_agent.html')' in the console.")
}