# author: Mengen Liu, Roy Oh, Kim Tan Palanca, Nicolas Zhu
# date: 2025-04-12

.PHONY: all clean report tests clean_data_validate train_data_validate test_data_validate remove_rplots

all: data/raw/maternal_health_risk.zip \
     data/raw/maternal_health_risk_data.csv \
     data/processed/cleaned_data.csv \
	 clean_data_validate \
	 outputs/csv/eda_summary.csv \
	 outputs/images/age_distribution.png \
	 outputs/images/correlation_matrix.png \
	 outputs/images/correlation_values.png \
     data/processed/train_data.csv \
     data/processed/test_data.csv \
	 train_data_validate \
	 test_data_validate \
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
	 docs/index.html \
	 tests \
	 remove_rplots

# load data
data/raw/maternal_health_risk.zip: scripts/01-load_data.R
	Rscript scripts/01-load_data.R --output="data/raw"

data/raw/maternal_health_risk_data.csv: scripts/01-load_data.R
	Rscript scripts/01-load_data.R --output="data/raw"

# clean data
data/processed/cleaned_data.csv: scripts/02-clean_data.R data/raw/maternal_health_risk_data.csv
	Rscript scripts/02-clean_data.R --input="data/raw/maternal_health_risk_data.csv" --output="data/processed"

# clean data validation
clean_data_validate:
	Rscript scripts/03-clean_data_validation.R

# EDA
outputs/csv/eda_summary.csv outputs/images/age_distribution.png outputs/images/correlation_matrix.png outputs/images/correlation_values.png: scripts/04-eda.R data/processed/cleaned_data.csv
	Rscript scripts/04-eda.R --input="data/processed/cleaned_data.csv" \
	--output_img="outputs/images" --output_csv="outputs/csv"

# split data
data/processed/train_data.csv data/processed/test_data.csv: scripts/05-split_data.R data/processed/cleaned_data.csv
	Rscript scripts/05-split_data.R --input="data/processed/cleaned_data.csv" \
	--output="data/processed"

# train data validation
train_data_validate:
	Rscript scripts/06-train_data_validation.R	

# test data validation
test_data_validate:
	Rscript scripts/07-test_data_validation.R	

# build baseline model
outputs/csv/baseline_predictions.csv outputs/csv/model_accuracies.csv: scripts/08-baseline_model.R data/processed/train_data.csv data/processed/test_data.csv
	Rscript scripts/08-baseline_model.R --train="data/processed/train_data.csv" --test="data/processed/test_data.csv" \
	--output="outputs/csv"

# train MLR model
outputs/models/mlr_model.rds outputs/csv/mlr_model_summary.csv: scripts/09-train_mlr_model.R data/processed/train_data.csv
	Rscript scripts/09-train_mlr_model.R --train="data/processed/train_data.csv" \
	--output_model="outputs/models" --output_csv="outputs/csv"

# test MLR model
outputs/csv/mlr_test_probabilities.csv outputs/csv/model_accuracies.csv: scripts/10-test_mlr_model.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript scripts/10-test_mlr_model.R --test="data/processed/test_data.csv" --model="outputs/models/mlr_model.rds" \
	--output="outputs/csv"

# graph MLR model
outputs/images/blood_sugar_plot.png: scripts/11-graph_mlr.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript scripts/11-graph_mlr.R --test="data/processed/test_data.csv" --model="outputs/models/mlr_model.rds" \
	--output_plot="outputs/images"

# train RF model
outputs/models/rf_model.rds: scripts/12-train_rf_model.R data/processed/train_data.csv
	Rscript scripts/12-train_rf_model.R --train="data/processed/train_data.csv" \
	--output="outputs/models"

# test RF model
outputs/csv/rf_predictions.csv outputs/csv/model_accuracies.csv: scripts/13-test_rf_model.R data/processed/test_data.csv outputs/models/mlr_model.rds
	Rscript scripts/13-test_rf_model.R --test="data/processed/test_data.csv" --model="outputs/models/rf_model.rds" \
	--output="outputs/csv/"

# RF model feature importances
outputs/images/rf_feature_importances.png: scripts/14-rf_feature_importances.R outputs/models/rf_model.rds
	Rscript scripts/14-rf_feature_importances.R --model="outputs/models/rf_model.rds" \
	--output="outputs/images/"

# baseline confusion matrix
outputs/csv/baseline_conf_matrix.csv outputs/images/baseline_conf_matrix.png: scripts/15-baseline_conf_matrix.R data/processed/test_data.csv outputs/csv/baseline_predictions.csv
	Rscript scripts/15-baseline_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/baseline_predictions.csv" \
	--output_csv="outputs/csv/" --output_img="outputs/images/"

# MLR confusion matrix
outputs/csv/mlr_conf_matrix.csv outputs/images/mlr_conf_matrix.png: scripts/16-mlr_conf_matrix.R data/processed/test_data.csv outputs/csv/mlr_test_probabilities.csv
	Rscript scripts/16-mlr_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/mlr_test_probabilities.csv" \
	--output_csv="outputs/csv" --output_img="outputs/images"

# RF confusion matrix
outputs/csv/rf_conf_matrix.csv outputs/images/rf_conf_matrix.png: scripts/17-rf_conf_matrix.R data/processed/test_data.csv outputs/csv/rf_predictions.csv
	Rscript scripts/17-rf_conf_matrix.R --test="data/processed/test_data.csv" --predictions="outputs/csv/rf_predictions.csv" \
	--output_csv="outputs/csv" --output_img="outputs/images"

# model comparison
outputs/images/conf_matrix_comparison.png outputs/csv/model_accuracies.csv outputs/csv/accuracy_comparison.csv outputs/images/accuracy_comparison.png: scripts/18-model_comparison.R outputs/csv outputs/images
	Rscript scripts/18-model_comparison.R --input_csv="outputs/csv" --input_img="outputs/images" \
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
		   outputs/agents/* \
	       outputs/csv/* \
	       outputs/images/* \
	       outputs/models/* \
	       reports/maternal_health_modeling.html \
		   reports/maternal_health_modeling.pdf \
		   docs/index.html

# test
tests:
	Rscript -e 'testthat::test_dir("tests/testthat")'

remove_rplots:
	@rm -f Rplots.pdf