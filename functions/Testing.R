# Generate predictions from a trained classification model
#
# This function loads a trained classification model from an rdd file and a test dataset. Then, 
# uses it to generate predictions.
# It can optionally return class probabilities if supported by the model.
#
# Parameters:
# - model_file (str): Path to the saved model file
# - test_data (DataFrame or tibble): Dataset containing the test features (target feature is removed)
# - return_probs (logical)_ If TRUE is selected, also returns class probabilities. NOTE: Default is FALSE
#
# Returns:
# - If return_probs = FALSE, returns a vector of predicted class labels
# - If return_probs = TRUE, returns a list with two elements:
#   - predictions: predicted class labels (Not the actual labels)
#   - probabilities: class probability matrix

testing <- function(model_file, test_data, return_probs = FALSE) {
    if (!is.logical(return_probs) || length(return_probs) != 1) {
        stop("return_probs must be TRUE or FALSE")
        }
    
    model <- readRDS(model_file)
    test_features <- test_data %>% select(-RiskLevel)
    predictions <- predict(model, newdata = test_features, type = "class")

    if (return_probs) {
        probs <- predict(model, newdata = test_features, type = "probs")
        return(list(predictions = predictions, probabilities = probs))
    }

    return(predictions)
}