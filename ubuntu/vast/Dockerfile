# syntax = docker/dockerfile:1.0-experimental
FROM ubuntu:20.04

## In order to avoid interupt for timezone setting
ENV DEBIAN_FRONTEND=noninteractive 

## This command is taken from https://raw.githubusercontent.com/egonzalf/rstudio-inla/master/Dockerfile 
## Then modified to add additional packages for instlation of rgl
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        build-essential \
#        gcc g++ gfortran \
        libfreetype6-dev \
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
  libfontconfig1-dev \
  wget \
  locales \
	file \
	tcl-dev \
	tk-dev	\
	&& apt-get autoremove -y && apt-get autoclean -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* 

##
# Add CRAN R repo to /etc/apt/sources.list
RUN apt-get update && apt-get  -y --no-install-recommends install gpg   ca-certificates dirmngr gpg-agent \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
	&& echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" | tee -a /etc/apt/sources.list \	
	&& apt-get update  \
	&& apt-get  -y --no-install-recommends install \
	r-base  \
 	r-base-dev \
  r-recommended \
	littler \
  && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
 	&& install.r docopt \
 	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && apt-get autoremove -y  \
	&& apt-get autoclean -y \
	&& apt-get  clean -y && rm -rf /var/lib/apt/lists/*

## Avoid error related to rgl package on headless see https://github.com/r-lib/remotes/issues/332
ENV RGL_USE_NULL  "TRUE"

# Sys.setenv(R_INSTALL_STAGED = FALSE)
ENV R_INSTALL_STAGED  FALSE

RUN R -e "options(repos = c('https://cloud.r-project.org/')); \
    update.packages(ask=FALSE)"

#RUN Rscript -e "options(repos = c('https://cloud.r-project.org/')); \
#    update.packages(ask=FALSE); \
#    install.packages('shiny');  \
#    install.packages(c('colorspace', 'assertthat', 'utf8', 'RColorBrewer', 'dichromat', 'munsell', 'labeling', 'viridisLite', 'cli', 'crayon', 'pillar', 'rlang', 'gtable', 'plyr', 'reshape2', 'scales', 'tibble', 'SparseM', 'dotCall64', 'lazyeval', 'ggplot2', 'miniUI', 'codetools', 'curl', 'openssl', 'backports', 'coda', 'MASS', 'mcmc', 'quantreg', 'lattice', 'spam', 'maps', 'htmlwidgets', 'crosstalk', 'manipulateWidget', 'polynom', 'httr', 'memoise', 'whisker', 'rstudioapi', 'git2r', 'withr', 'evaluate', 'highr', 'yaml', 'base64enc', 'rprojroot', 'MCMCpack', 'gtools', 'akima', 'ltsa', 'sp', 'Matrix', 'mvtnorm', 'numDeriv', 'fields', 'rgl', 'pixmap', 'splancs', 'orthopolynom', 'devtools', 'knitr', 'markdown', 'rmarkdown', 'rgdal', 'Deriv', 'HKprocess', 'FGN', 'MatrixModels'))" 

# RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('rnaturalearthdata','TMB'))" 

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
    'rnaturalearthdata' \
		'TMB' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages(c('shiny','littler','systemfonts'))"

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
    'shiny' \
    'systemfonts' \
    'devtools' \
		'remotes' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


#RUN R -e "options(repos = c('https://cloud.r-project.org/'));install.packages('BiocManager') ; \
#	BiocManager::install('Rgraphviz', update=FALSE, ask=FALSE)"

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
    'BiocManager' \
		&& R -e "BiocManager::install('Rgraphviz', update=FALSE, ask=FALSE)" \
		&& rm -rf /tmp/downloaded_packages/ /tmp/*.rd	

# RUN Rscript -e "options(repos = c('https://cloud.r-project.org/')); install.packages('TMB')"

## Install INLA 
# Define the version/repo of INLA to use. Choose either: 'stable' or 'testing'
ARG INLA_REPO='testing'

# RUN Rscript -e '.libPaths()'

# RUN ls -lh /usr/local/lib/R

# RUN ls -lh /usr/lib/R

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/', INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), \
  download.file.method = 'libcurl')" >> /usr/lib/R/etc/Rprofile.site


# RUN R -e "install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/$INLA_REPO'), dep=TRUE)" 

RUN install2.r   --error --ncpus -1 --skipinstalled -- --no-staged-install \
		'INLA' 'tidyverse' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds 


# Install FishStatsUtils from github
#RUN R -e "remotes::install_github('james-thorson/FishStatsUtils', INSTALL_opts='--no-staged-install')" 

# RUN installGithub.r 'james-thorson/FishStatsUtils'  && rm -rf /tmp/downloaded_packages/ /tmp/*.rd

RUN --mount=type=secret,id=dotenv,dst=/run/secrets/.env \
    set -a && . /run/secrets/.env && set +a \
  && installGithub.r 'james-thorson/FishStatsUtils' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install VAST from github
#RUN R -e "remotes::install_github('james-thorson/VAST', INSTALL_opts='--no-staged-install')" 

# RUN installGithub.r 'james-thorson/VAST' && rm -rf /tmp/downloaded_packages/ /tmp/*.rd

RUN --mount=type=secret,id=dotenv,dst=/run/secrets/.env set -a \
  && . /run/secrets/.env && set +a \
  && installGithub.r 'james-thorson/VAST' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN --mount=type=secret,id=dotenv,dst=/run/secrets/.env \
    set -a && . /run/secrets/.env && set +a \
  && installGithub.r 'james-thorson/Utilities' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## 2020-08-12 taken from p16 of https://mzdgnk.gitlab.io/r-ml/Docker/rstudio.html#16
# Change environment to Japanese(Character and DateTime)
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
### Needed to avoid error missing locale.gen https://qiita.com/kikako/items/5961628476abf61ee371
RUN apt-get update && \
	apt-get -y install  --no-install-recommends \
		language-pack-ja-base language-pack-ja 
RUN sed -i '$d' /etc/locale.gen \
  && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install ipaexfont
RUN apt-get update && apt-get install -y \
  		 --no-install-recommends \
			fonts-ipaexfont fonts-noto-cjk \
			&& apt-get clean && rm -rf /var/lib/apt/lists/*



## 2020-08-12 install missing sudo command

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        sudo

RUN apt-get update && \
    apt-get -y upgrade --no-install-recommends &&  \
    apt-get -y autoremove \
    && apt-get autoclean -y \
  	&& apt-get  clean -y && rm -rf /var/lib/apt/lists/* \
		&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds 

ENV USER vast
ENV PASSWORD vastuser

#RUN adduser $USER --disabled-password --home /home/$USER --gecos ""  && gpasswd -a $USER sudo 

RUN adduser $USER --disabled-password --home /home/$USER --gecos "" \
    && echo "$USER:$USER" | chpasswd \
    && addgroup $USER  staff

CMD chown $USER /home/$USER

USER $USER

#CMD R
CMD cd /home/$USER  &&  R

LABEL maintainer="Yukio Takeuchi"

