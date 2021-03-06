FROM rocker/r-base

## In order to avoid interupt for timezone setting
ENV DEBIAN_FRONTEND=noninteractive 

## This command is taken from https://raw.githubusercontent.com/egonzalf/rstudio-inla/master/Dockerfile 
## Then modified to add additional packages for instlation of rgl
## libfreetype6-dev is replaced with libfreetype-dev, as libfreetype6-dev is claimed as "transitional" on Debian
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        build-essential \
#        gcc g++ gfortran \
        libfreetype-dev \
        libgdal-dev \
        libglu1-mesa-dev \
#        libgraphviz-dev \
        libssl-dev \
        mesa-common-dev \
 	xserver-xorg-video-dummy \
	libudunits2-dev \
	libftgl-dev  \
        libgit2-dev \
	libssh2-1-dev \
	file \
	&& apt-get autoremove -y && apt-get autoclean -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* 

## Avoid error related to rgl package on headless see https://github.com/r-lib/remotes/issues/332
ENV RGL_USE_NULL  "TRUE"

RUN R -e "options(repos = c('https://cloud.r-project.org/')); \
    update.packages(ask=FALSE)"

#RUN Rscript -e "options(repos = c('https://cloud.r-project.org/')); \
#    update.packages(ask=FALSE); \
#    install.packages('shiny');  \
#    install.packages(c('colorspace', 'assertthat', 'utf8', 'RColorBrewer', 'dichromat', 'munsell', 'labeling', 'viridisLite', 'cli', 'crayon', 'pillar', 'rlang', 'gtable', 'plyr', 'reshape2', 'scales', 'tibble', 'SparseM', 'dotCall64', 'lazyeval', 'ggplot2', 'miniUI', 'codetools', 'curl', 'openssl', 'backports', 'coda', 'MASS', 'mcmc', 'quantreg', 'lattice', 'spam', 'maps', 'htmlwidgets', 'crosstalk', 'manipulateWidget', 'polynom', 'httr', 'memoise', 'whisker', 'rstudioapi', 'git2r', 'withr', 'evaluate', 'highr', 'yaml', 'base64enc', 'rprojroot', 'MCMCpack', 'gtools', 'akima', 'ltsa', 'sp', 'Matrix', 'mvtnorm', 'numDeriv', 'fields', 'rgl', 'pixmap', 'splancs', 'orthopolynom', 'devtools', 'knitr', 'markdown', 'rmarkdown', 'rgdal', 'Deriv', 'HKprocess', 'FGN', 'MatrixModels'))" 

# Sys.setenv(R_INSTALL_STAGED = FALSE)
ENV R_INSTALL_STAGED  FALSE

RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('shiny'))"

RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('rnaturalearthdata','TMB','devtools','rgl'))" 

RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages('BiocManager')  ;   BiocManager::install('Rgraphviz', update=FALSE, ask=FALSE)"

# RUN R -e "options(repos = c('https://cloud.r-project.org/')); install.packages('TMB')"

## Install INLA 
# Define the version/repo of INLA to use. Choose either: 'stable' or 'testing'
ARG INLA_REPO='stable'

RUN R -e "install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/$INLA_REPO') ,   dep=TRUE)" 

# Install FishStatsUtils from github
RUN R -e "remotes::install_github('james-thorson/FishStatsUtils', INSTALL_opts='--no-staged-install')" 

# Install VAST from github
RUN R -e "remotes::install_github('james-thorson/VAST', INSTALL_opts='--no-staged-install')" 

ENV USER vast
ENV PASSWORD vastuser

RUN adduser $USER --disabled-password --home /home/$USER --gecos ""  && gpasswd -a $USER sudo

USER $USER

CMD R

LABEL maintainer="Yukio Takeuchi"

