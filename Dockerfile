FROM rocker/tidyverse:4.4.2

WORKDIR /home/rstudio

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel
RUN python3 -m pip install --no-cache-dir jupyter jupyterlab

RUN R -e "install.packages('IRkernel', repos = 'https://cran.rstudio.com/')"
RUN R -e "IRkernel::installspec(user=FALSE)"

WORKDIR /home/rstudio

RUN R -e "install.packages(c('renv', 'remotes'), repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('ggplot2', version = '3.5.1', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('lattice', version = '0.22-6', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('corrplot', version = '0.95', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('nnet', version = '7.3-20', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('caret', version = '7.0-1', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('randomForest', version = '4.7-1.2', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('broom', version = '1.0.7', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('gridExtra', version = '2.3', repos = 'https://cran.rstudio.com/')"
RUN R -e "remotes::install_version('vip', version = '0.4.1', repos = 'https://cran.rstudio.com/')"

COPY README.md CODE_OF_CONDUCT.md CONTRIBUTING.md LICENSE.md /home/rstudio/
COPY data/ /home/rstudio/data/
COPY data_analysis.ipynb /home/rstudio/data_analysis.ipynb

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]