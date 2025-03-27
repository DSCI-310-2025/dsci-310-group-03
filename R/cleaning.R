# R/cleaning.R

#' Check Missing Values
#'
#' @param data A dataframe
#' @return A tibble of feature names and NA counts
#' @export
check_na <- function(data) {
  library(tibble)
  tibble(
    feature = names(data), 
    na = colSums(is.na(data)))
}

#' Get Unique Target Classes
#'
#' @param data A dataframe with target column
#' @param target The target column
#' @return A dataframe with unique values of the target column
#' @export
get_targets <- function(data, target) {
  library(dplyr)
  data %>% distinct({{ target }})
}

#' Get Unique Target Classes
#'
#' @param data A dataframe 
#' @param target The target column
#' @return A cleaned dataframe with missing values removed and the categorical target variable converted to a factor
#' @export
clean <- function(data, target) {
  library(dplyr)
  library(tidyr)
  target_col <- pull(data, {{ target }})

  if (is.character(target_col)) {
    data <- data %>%
    mutate({{ target }} := as.factor({{ target }})) 
  }
  data %>% drop_na()
}