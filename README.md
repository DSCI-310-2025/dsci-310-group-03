# Maternal Health Risk Prediction

Authors: Mengen Liu, Roy Oh, Kim Tan Palanca, Nicolas Zhu

## Project Summary
This project aims to evaluate the performances of two machine learning models (i.e., logistic regression and random forest)  in predicting maternal health risk. These models are developed to determine whether a pregnant woman is of low, medium, or high risk based on various health indicators. The models were assessed using classification metrics such as accuracy, precision, recall, F1-score, and AUC-ROC curve. 

The [dataset](https://archive.ics.uci.edu/dataset/863/maternal+health+risk) used in this project is originally sources from UC Irvine Machine Learning Respository, consisting of 1014 observations and 7 features related to patient physiological measurements. 

## How to Run the Data Analysis
To replicate this analysis, kindly follow the instructions below:
1. Clone repository
2. Set up environment
    - Install [Docker](https://www.docker.com/get-started/)
    - Build the docker image
    ``` 
    docker build -t dsci-310-group-03-docker
    ```
    - Run the docker container
    ```
    docker run -rm -it -p 8787:8787 dsci-310-group-03-docker
3. Run analysis
    - Open your preferred web browser to access Rstudio via http://localhost:8787
    - Open the file `data_analysis.ipynb`
    - Run the file

## List of Dependencies
- R version: 4.4.2
- R packages:
    - tidyverse
    - corrplot
    - nnet
    - caret

## Licenses
- This project is licensed under the MIT License. Kindly refer to [LISCENE.md](https://github.com/DSCI-310-2025/dsci-310-group-03/blob/main/LICENSE.md) for more.