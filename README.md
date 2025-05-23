# Maternal Health Risk Prediction

Authors: Mengen Liu, Roy Oh, Kim Tan Palanca, Nicolas Zhu

## Project Summary
This project aims to evaluate the performances of two machine learning models (i.e., logistic regression and random forest)  in predicting maternal health risk. These models are developed to determine whether a pregnant woman is of low, medium, or high risk based on various health indicators. The models were assessed using their respective accuracies in correctly predicting health risk status. 

The [dataset](https://archive.ics.uci.edu/dataset/863/maternal+health+risk) used in this project is originally sources from UC Irvine Machine Learning Respository, consisting of 1014 observations and 7 features related to patient physiological measurements. 

## Project Question

**Can we accurately predict the maternal health risk category (low, medium, or high) based on physiological indicators such as blood sugar levels, body temperature, and other relevant health factors?**

## Project Findings

### Best Performing Model
Our analysis indicates that maternal health risk during pregnancy can be predicted with an accuracy of 81.19% using a random forest decision tree model it is our most effective predictive approach. The second best model, multinomial logistic regression, achieved a 57.92% accuracy. Both outperforms the the baseline of 40.10%, which is good. These results align with past research, where random forests tend to perform better due to their ability to capture complex, non-linear relationships.

### Key Findings & Interpretation
While random forests provide strong predictive accuracy, multinomial logistic regression allows for greater interpretability by estimating how individual factors contribute to maternal health risk. The strongest predictors of high risk versus low risk were:

- Body temperature: A 1-unit increase was associated with a 2.29 $\times$ increase in the odds of being in the high-risk category.
- Blood sugar levels: A 1-unit increase increased the odds by 2.13 $\times$.

Both models performed best at identifying high-risk cases, suggesting that extreme maternal health risks are more distinguishable based on physiological indicators.

### Implications & Limitations
These findings suggest that body temperature and blood sugar levels are important factors in assessing maternal health risk. However, this does not imply causality—lowering these values may not necessarily reduce risk. Additionally, the analysis is limited by the number of variables included. Other important factors such as age, pre-existing health conditions, lifestyle, and socioeconomic factors could further refine the models and improve generalizability.

## What This Means
- These insights could help guide future maternal health research to explore whether these risk factors play a causal role in maternal health outcomes.
- Further studies could investigate whether certain age groups or demographics are more vulnerable to these risk factors.
- Medical professionals should not use this analysis for clinical decision-making, but it may inform broader research on maternal health monitoring.

## How to Run the Data Analysis
To replicate this analysis, kindly follow the instructions below:
1. Clone repository
2. Set up environment
    - Run the docker container
    ```
    docker-compose up
    ```
3. Open container
    - Open your preferred web browser to access Jupyter Lab via http://localhost:8787
4. Install tinytex
    - In the terminal of the RStudio container run:
    ```
    quarto install tinytex
    ```
5. Run analysis
- Run Makefile in terminal
    ```
    make all
    ```
The html file can be found inside the docs folder

6. Optional: If the analysis does not run completely, first run `make clean` and then run `make all` again.

## List of Dependencies
- R version: 4.4.2
- R packages:
    - readr (version = 2.1.4): CSV and tabular data reading
    - dplyr (version = 1.1.0): Data manipulation
    - tidyr (version = 1.3.0): Tools for tidying and reshaping data
    - tibble (version = 3.1.8): User-friendly data frames
    - ggplot2 (version = 3.5.1): Grammar of graphics for creating visualizations
    - lattice (version = 0.22-6): Trellis graphics for multivariate data
    - corrplot (version = 0.95): Visualization of correlation matrices
    - nnet (version = 7.3-20): Neural networks and multinomial logistic regression
    - caret (version = 7.0-1): Streamlined machine learning model training
    - randomForest (version = 4.7-1.2): Random forest implementation for classification and regression
    - broom (version = 1.0.7): Convert model outputs to tidy data frames
    - gridExtra (version = 2.3): Arrange multiple ggplot2 plots
    - vip (version = 0.4.1): Visualize variable importance for ML models
    - docopt (version = 0.7.1): Command-line argument parser using a help message
    - zip (version = 2.3.1): Create, list, and unzip zip archives
    - mgcv (version = 1.9-1): Generalized additive models and smoothers
    - png (version = 0.1-8): Read and write PNG images
    - ggcorrplot (version = 0.1.4): Correlation matrix visualization using ggplot2
    - rmarkdown (version = 2.26): Dynamic report generation with R Markdown
    - knitr (version = 1.45): Convert R Markdown to reports with embedded R code
    - patchwork (version = 1.3.0): Combine multiple ggplot2 plots
    - devtools (version = 2.4.5): Install GitHub package

## Licenses
- This project is licensed under the MIT License. Kindly refer to [LICENSE.md](https://github.com/DSCI-310-2025/dsci-310-group-03/blob/main/LICENSE.md) for more.
