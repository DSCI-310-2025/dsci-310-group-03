FROM rocker/rstudio:4.4.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    zlib1g-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libgit2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    && apt-get clean


RUN Rscript -e "install.packages(c('renv', 'remotes'), repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('readr', version = '2.1.4', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('dplyr', version = '1.1.0', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('tidyr', version = '1.3.0', repos = 'https://cran.rstudio.com/'); \
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
          remotes::install_version('tibble', version = '3.1.8', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('zip', version = '2.3.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('mgcv', version = '1.9-1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('png', version = '0.1-8', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('ggcorrplot', version = '0.1.4', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('rmarkdown', version = '2.26', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('knitr', version = '1.45', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('testthat', version = '3.1.10', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('pointblank', version = '0.12.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('patchwork', version = '1.3.0', repos = 'https://cran.rstudio.com/');"

RUN Rscript -e "remotes::install_version('devtools', version = '2.4.5', repos = 'https://cran.rstudio.com/'); \
                devtools::install_github('DSCI-310-2025/maternalhealthtools')"

