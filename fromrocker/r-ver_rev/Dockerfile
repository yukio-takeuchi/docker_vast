#
# Base image is based on r-ver instead of r-base 
#
# 2020-02-18 set tag to 3.6.2
# FROM rocker/r-ver:3.6.2
# 2020-03-02 set tag to latest (tags other than latest is missing 2020-03-02)
# 2020-05-13 update R version to 4.0.0 and set rocker/r-ver:4.0.0 to be used 
# 2020-05-27 Revised to use rocker/r-ver:4.0.0 as the base image
# 2020-08-10 Changed the base image to rocker/r-ver:4.0.2
# 2020-08-14 adapt date command for MacOS
# 2020-08-23 Change the base image back yo rocker/r-ver:4.0.0
# 2020-09-23 Chnage to 4.0.2 again
# 2020-10-15 Changed to r-ver:4.0.3 for base image 
FROM rocker/r-ver:4.0.3

## In order to avoid interupt for timezone setting
ENV DEBIAN_FRONTEND noninteractive 

ARG GITHUBUSERNAME=github_username 
ARG GITHUBPASSWORD=$github_password

## This command is taken from https://raw.githubusercontent.com/egonzalf/rstudio-inla/master/Dockerfile 
## Then modified to add additional packages for instlation of rgl
## libfreetype6-dev is replaced with libfreetype-dev, as libfreetype6-dev is claimed as "transitional" on Debian
## R package git2r requires zlib1g-dev libgit2-dev
## R package curl requires libcurl4-openssl-dev
## R package openssl requires libssl-dev
## R package xml2 requires libxml2-dev
## R package rgl requires xserver-xorg-video-dummy libpng-dev libx11-dev mesa-common-dev libglu1-mesa-dev
## R package rgl checks if pkg-config is installed
## R package rgdal requires libgdal-dev 
## R package units requires libudunits2-dev
RUN apt-get update && \
    apt-get -y upgrade --no-install-recommends &&  \
    apt-get -y install --no-install-recommends \
        build-essential \
	libssl-dev \
	zlib1g-dev \ 
        libgit2-dev \
	libcurl4-openssl-dev \
	libxml2-dev \
	xserver-xorg-video-dummy \
	libpng-dev \
	libx11-dev \
	pkg-config \
	libudunits2-dev \
	libgdal-dev \
  libglu1-mesa-dev \
  libfreetype-dev \
        && apt-get autoremove -y && apt-get autoclean -y \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

#        gcc g++ gfortran \
#        libgdal-dev \
#        libglu1-mesa-dev \
#        libgraphviz-dev \
#        libssl-dev \
#        mesa-common-dev \
# 	xserver-xorg-video-dummy \
#	libudunits2-dev \
#	libftgl-dev  \
#        libgit2-dev \
#	libssh2-1-dev \
#	file \
#	&& apt-get autoremove -y && apt-get autoclean -y \
#	&& apt-get clean && rm -rf /var/lib/apt/lists/* 

#RUN apt-get update && \
#    apt-get -y upgrade --no-install-recommends &&  \
#    apt-get -y autoremove && 


## Avoid error related to rgl package on headless see https://github.com/r-lib/remotes/issues/332
ENV RGL_USE_NULL  "TRUE"

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), \
  download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site

RUN R -e "options(repos = c('https://cran.rstudio.com/')); \
    update.packages(ask=FALSE)"

#RUN Rscript -e "options(repos = c('https://cloud.r-project.org/')); \
#    update.packages(ask=FALSE); \
#    install.packages('shiny');  \
#    install.packages(c('colorspace', 'assertthat', 'utf8', 'RColorBrewer', 'dichromat', 'munsell', 'labeling', 'viridisLite', 'cli', 'crayon', 'pillar', 'rlang', 'gtable', 'plyr', 'reshape2', 'scales', 'tibble', 'SparseM', 'dotCall64', 'lazyeval', 'ggplot2', 'miniUI', 'codetools', 'curl', 'openssl', 'backports', 'coda', 'MASS', 'mcmc', 'quantreg', 'lattice', 'spam', 'maps', 'htmlwidgets', 'crosstalk', 'manipulateWidget', 'polynom', 'httr', 'memoise', 'whisker', 'rstudioapi', 'git2r', 'withr', 'evaluate', 'highr', 'yaml', 'base64enc', 'rprojroot', 'MCMCpack', 'gtools', 'akima', 'ltsa', 'sp', 'Matrix', 'mvtnorm', 'numDeriv', 'fields', 'rgl', 'pixmap', 'splancs', 'orthopolynom', 'devtools', 'knitr', 'markdown', 'rmarkdown', 'rgdal', 'Deriv', 'HKprocess', 'FGN', 'MatrixModels'))" 

# Sys.setenv(R_INSTALL_STAGED = FALSE)
ENV R_INSTALL_STAGED  FALSE



# RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('shiny'))"

RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'Rcpp'

RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'shiny'

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'rgl'


######


#RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('rnaturalearthdata','TMB','devtools','rgl','rgdal'))" 

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'rnaturalearthdata'

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'RcppEigen'

RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'TMB'

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'roxygen2'

RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'devtools' 


RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'rgdal' 

#RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages('BiocManager')  ;   BiocManager::install('Rgraphviz', update=FALSE, ask=FALSE)"

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'BiocManager'

RUN R -e "BiocManager::install('Rgraphviz', update=FALSE, ask=FALSE)"

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'sf'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'RcppArmadillo'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'maps'

RUN install2.r  'fields' --error --ncpus -1 --skipinstalled  -- --no-staged-install

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'spdep'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'dplyr'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'rgeos'

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install 'tinytex'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'rmarkdown'

RUN install2.r   --error --ncpus -1 --skipinstalled  -- --no-staged-install 'foreach'

# RUN R -e "options(repos = c('https://cloud.r-project.org/')); install.packages('TMB')"

## Install INLA 
# Define the version/repo of INLA to use. Choose either: 'stable' or 'testing'
# Note 2020-10-15 As of now no stable version of INLA available. So use testing version instead
ARG INLA_REPO='testing'

#RUN R -e "install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/$INLA_REPO') ,   dep=TRUE)" 

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/', INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), \
  download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site

RUN install2.r  --error --ncpus -1 --skipinstalled -- --no-staged-install 'INLA' 

# Install FishStatsUtils from github
#RUN R -e "remotes::install_github('james-thorson/FishStatsUtils', INSTALL_opts='--no-staged-install', auth_token = $GITHUBPASSWORD)" 

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
                statmod   \
                nloptr   \    
                minqa    \    
                lme4     
                

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
                doParallel   \
                plyr         \
                zoo          \
                intervals    

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
                xts \
                FNN          \
                spacetime    \
                shapefiles   \
                gstat        \
                colorspace   \
                viridisLite  \
                RColorBrewer \
                munsell      \
                labeling     \
                farver       \
                plotrix      \
                scales       \
                reshape      \
                ps           

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install glmmTMB      
                

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
                qgam         \
                sfsmisc      

RUN install2.r     --error --ncpus -1 --skipinstalled -- --no-staged-install \
                  ape \
                  lmtest       \
                  gap   \       
                  RSAGA        \
                  colorRamps   \
                  pixmap       \      
                  dismo       \
                  aqp          \
                  XML          \
                  segmented    \
                  kernlab      \
                  RandomFieldsUtils \
                  DHARMa       \
                  splancs      \
                  formatR      

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
                rnaturalearth \
                pander       \
                corpcor      \
                abind        \
                MatrixModels \
                plotKML      \
                mixtools     \
                shape        \
                RandomFields \
                RANN         \
                maptools     \
                mapproj      
                

RUN installGithub.r 'james-thorson/FishStatsUtils'

# Install VAST from github
#RUN R -e "remotes::install_github('james-thorson/VAST', INSTALL_opts='--no-staged-install' , auth_token = $GITHUBPASSWORD)" 

RUN installGithub.r 'james-thorson/VAST'

## 2020-08-12 Add ThorsonUtilities as it is required from VAST
## It seems it is implicitely installed 
#RUN R -e "remotes::install_github('james-thorson/Utilities', INSTALL_opts='--no-staged-install' , auth_token = $GITHUBPASSWORD)"

RUN installGithub.r 'james-thorson/Utilities'

## 2020-08-12
# Change environment to Japanese(Character and DateTime)
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install ipaexfont
# 2020-10-14 Add fonts-noto-cjk based on 
# https://k-metrics.github.io/cabinet/env_install_svr.html
RUN apt-get update && apt-get install -y \
  fonts-ipaexfont fonts-noto-cjk

## 2020-06-21 install missing sudo command

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        sudo

RUN apt-get update && \
    apt-get -y upgrade --no-install-recommends &&  \
    apt-get -y autoremove

ENV USER vast
ENV PASSWORD vastuser

RUN adduser $USER --disabled-password --home /home/$USER --gecos ""  && echo "$USER:$USER" | chpasswd && gpasswd -a $USER sudo

USER $USER

CMD cd /home/$USER  &&  R

LABEL maintainer="Yukio Takeuchi"

