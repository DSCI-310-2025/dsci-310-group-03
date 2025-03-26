source("../../R/visualization.R")

library(caret)
library(tidyverse)
library(testthat)
library(nnet)

# create blood sugar plot to compare ggplot object with function output
#test_data <- read_csv("data/processed/test_data.csv")
#multinom_model <- readRDS("outputs/models/mlr_model.rds")


set.seed(123)  


helper_test_data <- tibble(
  Age = sample(10:50, 100, replace = TRUE),  
  SystolicBP = sample(seq(70, 140, by = 10), 100, replace = TRUE), 
  DiastolicBP = sample(seq(50, 90, by = 10), 100, replace = TRUE), 
  BS = round(runif(100, 6.5, 13), 2),  
  BodyTemp = rep(98, 100) + rnorm(100, mean = 0, sd = 0.5),  
  HeartRate = sample(seq(70, 100, by = 2), 100, replace = TRUE),  
  RiskLevel = sample(c("low risk", "mid risk", "high risk"), 100, replace = TRUE)
) %>% 
  mutate(RiskLevel = factor(RiskLevel, levels = c("low risk", "mid risk", "high risk"))) %>%
  mutate(RiskLevel = relevel(RiskLevel, ref = "low risk"))

helper_mlr_model <- multinom(RiskLevel ~ ., data = helper_test_data) # training the model on test data only for function test purposes

helper_pred_probs <- predict(helper_mlr_model, newdata = helper_test_data, type = "probs")
helper_prob_data <- as.data.frame(helper_pred_probs)

prob_data$BS <- test_data$BS  


prob_long <- pivot_longer(prob_data, cols = c("low risk", "mid risk", "high risk"), 
                          names_to = "RiskLevel", values_to = "Probability")


blood_sugar_plot <- ggplot(prob_long, aes(x = BS, y = Probability, color = RiskLevel)) +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = 'cs'), se = FALSE, size = 1) +  
  theme_minimal() +
  labs(title = "Predicted Probabilities Across Blood Sugar Levels",
       x = "Blood Sugar (BS)",
       y = "Predicted Probability") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

generate_probs <- function(n) {
  probs <- matrix(runif(n * 3), nrow = n)
  probs <- probs / rowSums(probs)  # Normalize to ensure they sum to 1
  as.data.frame(probs)
}

helper_data_conf_pred <- tibble(
  ID = 1:100,  
  Predicted_Class = sample(c("low risk", "mid risk", "high risk"), 100, replace = TRUE),
  `low risk` = generate_probs(100)[, 1],
  `mid risk` = generate_probs(100)[, 2],
  `high risk` = generate_probs(100)[, 3]
)


helper_data_conf_pred <- helper_data_conf_pred %>%
  rowwise() %>%
  mutate(
    Total = sum(`low risk`, `mid risk`, `high risk`)
  ) %>%
  mutate(across(`low risk`:`high risk`, ~ ./Total)) %>%  
  select(-Total) 

helper_conf_matrix <- confusionMatrix(as.factor(helper_data_conf_pred$Predicted_Class), as.factor(helper_test_data$RiskLevel))

helper_conf_table <- as.data.frame(helper_conf_matrix$table)
colnames(helper_conf_table) <- c("True", "Predicted", "Frequency")
helper_conf_table <- helper_conf_table %>%
  mutate(True = factor(True, levels = c("low risk", "mid risk", "high risk")),
         Predicted = factor(Predicted, levels = c("low risk", "mid risk", "high risk"))) %>%
  group_by(True) %>%
  mutate(Percentage = ifelse(is.na(Frequency), 0, round((Frequency / sum(Frequency)) * 100, 1)))



helper_plot_conf <- Viz("conf_matrix", helper_conf_table, "mlr", "outputs")
# testing cases

test_that("`Viz()` should return the correct file name in the specified location.", {
  Viz("conf_matrix", helper_conf_table, "mlr", "outputs/images")
  expect_true(file.exists("outputs/images/mlr_conf_matrix.png"))
})



test_that("`Viz()` should use `geom_tile()` for `conf_matrix` and map x label to True Label and y label to Predicted Label, 
          use `geom_smooth` and map x-axis to BS and y-axis to Probability for 'pred_prob',
          map x-axis to Feature and y-axis to Importance for 'pred_prob'", {
  
  expect_true("GeomTile" %in% c(class(helper_plot_conf$layers[[1]]$geom)))
  expect_true(helper_plot_conf$labels$x == "True Label")
  expect_true(helper_plot_conf$labels$y == "Predicted Label")
  expect_true(helper_plot_conf$data == helper_conf_table)
  
  expect_true("GeomSmooth" %in% c(class(helper_plot_pred_prob$layers[[1]]$geom)))
  expect_true(helper_plot_pred_prob$labels$x == "BS")
  expect_true(helper_plot_pred_prob$labels$y == "Probability")
  expect_true(helper_plot_pred_prob$data ==prob_long)
  
  expect_true(helper_plot_feat_imp$labels$x == "Feature")
  expect_true(helper_plot_feat_imp$labels$y == "Importance")
})

# check if using the right data in the plot


test_that("`Viz` should throw an error when invalid parameters are used.", {
  expect_error(Viz("pred_prob", prob_long, NULL, 123))
  expect_error(Viz("pred_prob", prob_long, "outputs/images"))
  expect_error(Viz(pred_prob, prob_long, NULL, "outputs/images"))
  expect_error(Viz("pred_prob", "prob_long", NULL, "outputs/images"))
  expect_error(Viz("pred_prob", prob_long, "mlr", "outputs/images"))
  expect_error(Viz("predicted_prob", prob_long, NULL, "outputs/images"))
  expect_error(Viz("conf_matrix", mlr_table, mlr, "outputs/images"))
  expect_error(Viz("conf_matrix", mlr_table, "regression", "outputs/images"))
  expect_error(Viz("confusion_matrix", mlr_table, "mlr", "outputs/images"))
})