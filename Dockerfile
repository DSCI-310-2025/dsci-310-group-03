FROM rocker/rstudio:4.4.2

WORKDIR /home/rstudio

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libxt6 \
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('renv', 'remotes', 'reticulate'), repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('ggplot2', version = '3.5.1', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('lattice', version = '	0.22-6', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('corrplot', version = '0.95', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('nnet', version = '7.3-20', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('caret', version = '7.0-1', repos = 'https://cran.rstudio.com/')"

COPY renv.lock /home/rstudio/renv.lock
RUN R -e "renv::restore()"

COPY README.md CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE.md /home/rstudio/
COPY data/ /home/rstudio/data/
COPY data_analysis.ipynb /home/rstudio/data_analysis.ipynb

EXPOSE 8787

CMD ["/init"]