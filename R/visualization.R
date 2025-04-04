#' Create visualizations
#'
#' Creates and predicted probability, confusion matrices or
#' random forest feature importance plots
#'
#' @param plot_type Character string specifying the type of plot to generate. 
#'   Must be one of:
#'   - `"conf_matrix"` for confusion matrix visualization
#'   - `"feature_importance"` for feature importance plot
#'   - `"pred_prob"` for predicted probabilities plot
#'
#' @param input The input file for the visualization:
#'   - For `"conf_matrix"`: A data frame containing the confusion matrix data with 
#'     columns `True`, `Predicted`, `Frequency`, and `Percentage`.
#'   - For `"feature_importance"`: A trained model object (e.g., Random Forest model) 
#'     for extracting feature importance scores.
#'   - For `"pred_prob"`: A data frame containing predicted probabilities with 
#'     columns `BS` (blood sugar levels) and `Probability`.
#'
#' @param conf_type Character string specifying the confusion matrix type. 
#'   Required only if `plot_type = "conf_matrix"`. Must be one of:
#'   - `"baseline"` for the Baseline Confusion Matrix
#'   - `"mlr"` for the MLR Confusion Matrix
#'   - `"rf"` for the Random Forest Confusion Matrix
#'   If not using `plot_type = "conf_matrix"`, then specify `NULL`
#'
#' @param output_dir Character string specifying the directory path where the 
#'   output plot will be saved. Ensure the directory exists.
#'
#' @return saves the generated plot as a .png file in the specified `output_dir`.
#'   
#' @export
#' @examples
#' you need a folder in the current working directory called "outputs"
#' helper_conf_table <- data.frame(
#'                True = c("low risk", "mid risk", "high risk",
#'                        "low risk", "mid risk", "high risk",
#'                        "low risk", "mid risk", "high risk"),
#'                Predicted = c("low risk", "low risk", "low risk",
#'                                "mid risk", "mid risk", "mid risk",
#'                                "high risk", "high risk", "high risk"),
#'                Frequency = c(9, 17, 9, 10, 6, 9, 8, 14, 18),
#'                Percentage = c(33.3, 45.9, 25.0, 37.0, 16.2, 25.0, 29.6, 37.8, 50.0))
#'                
#' visualization("conf_matrix", helper_conf_table, "mlr", "outputs")

visualization <- function(plot_type, input, conf_type, output_dir){
    
    # check parameter types
    if (!is.null(conf_type) && plot_type != "conf_matrix") {
        stop("`conf_type` should only be used with `plot_type = 'conf_matrix'`.")
    }

    if (!is.character(output_dir)) {
        stop("`output_dir` must be a character string representing the path.")
    }

    # Confusion matrix plots
    if (plot_type == "conf_matrix") {
        if (is.null(conf_type)) {
            stop("'conf_type' is required for 'conf_matrix' plot_type.")
        }

        conf_matrix_title <- switch(conf_type,
                                "baseline" = "Baseline Confusion Matrix",
                                "mlr" = "MLR Confusion Matrix",
                                "rf" = "Random Forest Confusion Matrix",
                                stop("Invalid 'conf_type'. Use 'base', 'mlr', or 'rf'."))

        plot <- ggplot(input, aes(x = True, y = Predicted, fill = Frequency)) +
            geom_tile(color = "black") +
            geom_text(aes(label = paste0(Frequency, "\n(", Percentage, "%)")), color = "black", size = 6) +
            scale_fill_gradient(low = "white", high = "blue") +
            labs(title = conf_matrix_title, x = "True Label", y = "Predicted Label") +
            theme_minimal() +
            theme(plot.title = element_text(hjust = 0.5, face = "bold"))

        output_path <- file.path(output_dir, paste0( conf_type, "_conf_matrix.png"))

    # RF feature importance plot
    } else if (plot_type == "feature_importance") {
        plot <- vip(input) +
            labs(title = 'Random Forest Feature Importance', 
                 x = "Feature", y = "Importance") +
            theme_minimal() +
            theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

        output_path <- file.path(output_dir, "rf_feature_importance.png")

    # Predicted probabilities plot
    } else if (plot_type == "pred_prob") {
        plot <- ggplot(input, aes(x = BS, y = Probability, color = RiskLevel)) +
            geom_smooth(method = "gam", formula = y ~ s(x, bs = 'cs'), se = FALSE, linewidth = 1) +
            theme_minimal() +
            labs(title = "Predicted Probabilities Across Blood Sugar Levels",
                 x = "Blood Sugar (BS)", y = "Predicted Probability") +
            theme(plot.title = element_text(hjust = 0.5, face = "bold"))

        output_path <- file.path(output_dir,"blood_sugar_plot.png")

    } else {
        stop("Invalid plot type. Please use 'feature_importance', 'pred_prob', or 'conf_matrix'")
    }
    
    ggsave(output_path, plot, width = 8, height = 6, dpi = 300)
    return(plot)

}
