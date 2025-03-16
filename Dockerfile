FROM rocker/rstudio:4.4.2

RUN Rscript -e "install.packages(c('renv', 'remotes'), repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('ggplot2', version = '3.5.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('lattice', version = '0.22-6', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('corrplot', version = '0.95', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('nnet', version = '7.3-20', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('caret', version = '7.0-1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('randomForest', version = '4.7-1.2', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('broom', version = '1.0.7', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('gridExtra', version = '2.3', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('vip', version = '0.4.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('docopt', version = '0.7.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('httr', version = '1.4.7', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('readr', version = '2.1.5', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('zip', version = '2.3.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('mgcv', version = '1.9-1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('png', version = '0.1-8', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('ggcorrplot', version = '0.1.4', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('rmarkdown', version = '2.26', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('knitr', version = '1.45', repos = 'https://cran.rstudio.com/');"

COPY README.md \
CODE_OF_CONDUCT.md \
CONTRIBUTING.md \
data \
reports \
rscript_files \
Makefile \
/home/rstudio/
     



