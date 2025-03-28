# author: Mengen Liu, Roy Oh, Kim Tan Palanca, Nicolas Zhu
# date: 2025-05-15

.PHONY: all clean report tests

all: data/raw/maternal_health_risk.zip \
     data/raw/maternal_health_risk_data.csv \
     data/processed/cleaned_data.csv \
	 outputs/csv/eda_summary.csv \
	 outputs/images/age_distribution.png \
	 outputs/images/correlation_matrix.png \
	 outputs/images/correlation_values.png \
     data/processed/train_data.csv \
     data/processed/test_data.csv \
     outputs/csv/baseline_predictions.csv \
     outputs/models/mlr_model.rds \
     outputs/csv/mlr_model_summary.csv \
     outputs/csv/mlr_test_probabilities.csv \
     outputs/images/blood_sugar_plot.png \
     outputs/models/rf_model.rds \
     outputs/csv/rf_predictions.csv \
     outputs/images/rf_feature_importances.png \
     outputs/csv/baseline_conf_matrix.csv \
     outputs/images/baseline_conf_matrix.png \
     outputs/csv/mlr_conf_matrix.csv \
     outputs/images/mlr_conf_matrix.png \
     outputs/csv/rf_conf_matrix.csv \
     outputs/images/rf_conf_matrix.png \
     outputs/images/conf_matrix_comparison.png \
	 outputs/csv/model_accuracies.csv \
     outputs/csv/accuracy_comparison.csv \
     outputs/images/accuracy_comparison.png \
	 reports/maternal_health_modeling.html \
	 reports/maternal_health_modeling.pdf \
	 docs/index.html

# load data
data/raw/maternal_health_risk.zip: rscript_files/01-load_data.R
	Rscript rscript_files/01-load_data.R --output="data/raw"

data/raw/maternal_health_risk_data.csv: rscript_files/01-load_data.R
	Rscript rscript_files/01-load_data.R --output="data/raw"

# clean data
data/processed/cleaned_data.csv: rscript_files/02-clean_data.R data/raw/maternal_health_risk_data.csv
	Rscript rscript_files/02-clean_data.R --input="data/raw/maternal_health_risk_data.csv" --output="data/processed"

# EDA
outputs/csv/eda_summary.csv outputs/images/age_distribution.png outputs/images/correlation_matrix.png outputs/images/correlation_values.png: rscript_files/03-eda.R data/processed/cleaned_data.csv
	Rscript rscript_files/03-eda.R --input="data/processed/cleaned_data.csv" \
	--output_img="outputs/images" --output_csv="outputs/csv"

# split data
data/processed/train_data.csv data/processed/test_data.csv: rscript_files/04-split_data.R data/processed/cleaned_data.csv
	Rscript rscript_files/04-split_data.R --input="data/processed/cleaned_data.csv" \
	--output="data/processed"

# build baseline model
outputs/csv/baseline_predictions.csv outputs/csv/model_accuracies.csv: rscript_files/05-baseline_model.R data/processed/train_data.csv data/processed/test_data.csv
	Rscript rscript_files/05-baseline_model.R --train="data/processed/train_data.csv" --test="data/processed/test_data.csv" \
	--output="outputs/csv"

# train MLR model
outputs/models/mlr_model.rds outputs/csv/mlr_model_summary.csv: rscript_files/06-train_mlr_model.R data/processed/train_data.csv
	Rscript rscript_files/06-train_mlr_model.R --train="data/processed/train_data.csv" \
	--output_model="outputs/models" --output_csv="outputs/csv"

# test MLR model
outputs/csv/mlr_test_probabilities.csv outputs/csv/model_accuracies.csv: rscript_files/07-test_mlr_model.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript rscript_files/07-test_mlr_model.R --test="data/processed/test_data.csv" --model="outputs/models/mlr_model.rds" \
	--output="outputs/csv"

# graph MLR model
outputs/images/blood_sugar_plot.png: rscript_files/08-graph_mlr.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript rscript_files/08-graph_mlr.R --test="data/processed/test_data.csv" --model="outputs/models/mlr_model.rds" \
	--output_plot="outputs/images"

# train RF model
outputs/models/rf_model.rds: rscript_files/09-train_rf_model.R data/processed/train_data.csv
	Rscript rscript_files/09-train_rf_model.R --train="data/processed/train_data.csv" \
	--output="outputs/models"

# test RF model
outputs/csv/rf_predictions.csv outputs/csv/model_accuracies.csv: rscript_files/10-test_rf_model.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript rscript_files/10-test_rf_model.R --test="data/processed/test_data.csv" --model="outputs/models/rf_model.rds" \
	output="outputs/csv/"

# RF model feature importances
outputs/images/rf_feature_importances.png: rscript_files/11-rf_feature_importances.R outputs/models/rf_model.rds
	Rscript rscript_files/11-rf_feature_importances.R --model="outputs/models/rf_model.rds" \
	--output="outputs/images/"

# baseline confusion matrix
outputs/csv/baseline_conf_matrix.csv outputs/images/baseline_conf_matrix.png: rscript_files/12-baseline_conf_matrix.R data/processed/test_data.csv outputs/csv/baseline_predictions.csv
	Rscript rscript_files/12-baseline_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/baseline_predictions.csv" \
	--output_csv="outputs/csv/" --output_img="outputs/images/"

# MLR confusion matrix
outputs/csv/mlr_conf_matrix.csv outputs/images/mlr_conf_matrix.png: rscript_files/13-mlr_conf_matrix.R data/processed/test_data.csv outputs/csv/mlr_test_probabilities.csv
	Rscript rscript_files/13-mlr_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/mlr_test_probabilities.csv" \
	--output_csv="outputs/csv" --output_img="outputs/images"

outputs/csv/rf_conf_matrix.csv outputs/images/rf_conf_matrix.png: rscript_files/14-rf_conf_matrix.R data/processed/test_data.csv outputs/csv/rf_predictions.csv
	Rscript rscript_files/14-rf_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/rf_predictions.csv" \
	--output_csv="outputs/csv" --output_img="outputs/images"

# RF confusion matrix
outputs/csv/rf_predictions.csv outputs/csv/model_accuracies.csv: rscript_files/10-test_rf_model.R data/processed/test_data.csv outputs/models/rf_model.rds
	Rscript rscript_files/10-test_rf_model.R --test="data/processed/test_data.csv" --model="outputs/models/rf_model.rds" \
	--output="outputs/csv/"

# model comparison
outputs/images/conf_matrix_comparison.png outputs/csv/model_accuracies.csv outputs/csv/accuracy_comparison.csv outputs/images/accuracy_comparison.png: rscript_files/15-model_comparison.R outputs/csv outputs/images
	Rscript rscript_files/15-model_comparison.R --input_csv="outputs/csv" --input_img="outputs/images" \
	--output_csv="outputs/csv" --output_img="outputs/images"

# render quarto report 
reports/maternal_health_modeling.html: reports/maternal_health_modeling.qmd 
	quarto render reports/maternal_health_modeling.qmd --to html

reports/maternal_health_modeling.pdf: reports/maternal_health_modeling.qmd 
	quarto render reports/maternal_health_modeling.qmd --to pdf

docs/index.html: reports/maternal_health_modeling.html
	cp reports/maternal_health_modeling.html docs/index.html

# clean
clean:
	rm -rf data/processed/* \
	       data/raw/* \
	       outputs/csv/* \
	       outputs/images/* \
	       outputs/models/* \
	       reports/maternal_health_modeling.html \
		   reports/maternal_health_modeling.pdf \
		   docs/index.html

# test
tests:
	Rscript -e 'testthat::test_dir("tests/testthat")'