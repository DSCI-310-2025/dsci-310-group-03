FROM rocker/rstudio:4.4.2

RUN R -e "install.packages('tidyverse', repos = 'https://cran.rstudio.com/', version = '2.0.0')"

COPY README.md /home/rstudio/README.md
COPY CODE_OF_CONDUCT.md /home/rstudio/CODE_OF_CONDUCT.md 
COPY CONTRIBUTING.md /home/rstudio/CONTRIBUTING.md 
COPY LICENSE.md /home/rstudio/CONTRIBUTING.md 
COPY data/ /home/rstudio/data/