FROM rocker/rstudio:4.4.2

RUN R -e "install.packages(c('renv', 'remotes', 'reticulate'), repos = 'https://cran.rstudio.com/')"

RUN R -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cran.rstudio.com/')"

#RUN R -e "reticulate::py_install('pandas', envname = 'r-reticulate', pip = TRUE)"

COPY README.md /home/rstudio/README.md
COPY CODE_OF_CONDUCT.md /home/rstudio/CODE_OF_CONDUCT.md 
COPY CONTRIBUTING.md /home/rstudio/CONTRIBUTING.md 
COPY LICENSE.md /home/rstudio/CONTRIBUTING.md 
COPY data/ /home/rstudio/data/