FROM quay.io/jupyter/r-notebook:notebook-7.3.2

WORKDIR /home/jovyan

RUN R -e "install.packages(c('renv', 'remotes'), repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('ggplot2', version = '3.5.1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('lattice', version = '0.22-6', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('corrplot', version = '0.95', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('nnet', version = '7.3-20', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('caret', version = '7.0-1', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('randomForest', version = '4.7-1.2', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('broom', version = '1.0.7', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('gridExtra', version = '2.3', repos = 'https://cran.rstudio.com/'); \
          remotes::install_version('vip', version = '0.4.1', repos = 'https://cran.rstudio.com/')"

COPY README.md CODE_OF_CONDUCT.md CONTRIBUTING.md CC0-LICENSE MIT-LICENSE data/ report/maternal_health_modeling.ipynb /home/jovyan/

USER root
RUN fix-permissions /home/jovyan
USER jovyan

EXPOSE 8888

CMD ["start-notebook.sh", "--NotebookApp.token=''"]

