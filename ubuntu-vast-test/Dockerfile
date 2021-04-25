# syntax = docker/dockerfile:experimental
#
# run docker build  --secret id=dotenv,src=./.env . -t ubuntu-jp
#
# Dockerfile to enable Japanes locale
#ubuntuの18.04の最小イメージから構築
#まっさらな状態からの場合はscratchとする
FROM ubuntu:20.04
## In order to avoid interupt for timezone setting
ENV DEBIAN_FRONTEND noninteractive
## Avoid error related to rgl package on headless see https://github.com/r-lib/remotes/issues/332
ENV RGL_USE_NULL  "TRUE"


#イメージ作成時にRUNで事前にコマンドラインを実行できる
#パッケージリストを更新
RUN apt-get update && \
    apt-get -y upgrade --no-install-recommends &&  \
    apt-get -y install --no-install-recommends \
        build-essential \
    gfortran \
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
  libfontconfig1-dev \
  tcl-dev \
  tk-dev \
  wget \
  ca-certificates \
  fonts-ipaexfont \
  fonts-noto-cjk \
  && apt-get autoremove -y && apt-get autoclean -y \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Shift timezone to Asia/Tokyo.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    tzdata && \
    apt-get autoremove -y && apt-get autoclean -y \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo


#日本語化パッケージリストをインストール
RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
    language-pack-ja-base language-pack-ja locales && \
   apt-get autoremove -y && apt-get autoclean -y \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

#localeを日本語設定に変更
RUN locale-gen ja_JP.UTF-8
#言語を日本語に設定
ENV LANG ja_JP.UTF-8

RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
    gdebi-core curl libbz2-dev && \
    apt-get autoremove -y && apt-get autoclean -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

## Install R
ENV R_VERSION=4.0.5

RUN curl -O  \
    https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-${R_VERSION}_1_amd64.deb 

RUN apt-get update && \
    apt-get install -y \
    libcairo2    \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpaper-utils \
    libpcre2-dev \
    unzip \
    zip \
    && apt-get autoremove -y && apt-get autoclean -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN gdebi -n r-${R_VERSION}_1_amd64.deb

RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/

RUN  ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/R/${R_VERSION}/lib/R/lib

RUN touch /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

ENV PRPMBIN='https://packagemanager.rstudio.com/all/__linux__/focal/latest'

ENV PRPMSOURCE='https://packagemanager.rstudio.com/all/latest'

ENV PRPM=${PRPMBIN}

## binary packages from public RStudio package manager
RUN echo "options(repos = structure(c(PRPM = \"${PRPM}\")))" >> \
			/opt/R/${R_VERSION}/lib/R/etc/Rprofile.site 

## source  packages from public RStudio package manager
#RUN echo "options(repos = structure(c(PRPM = \"${PRPMSOURCE}\")))" >> \
#      /opt/R/${R_VERSION}/lib/R/etc/Rprofile.site

# Sys.setenv(R_INSTALL_STAGED = FALSE)
ENV R_INSTALL_STAGED  FALSE

RUN R -e "install.packages('littler', repos = \"${PRPMSOURCE}\")"

RUN ln -s /opt/R/${R_VERSION}/lib/R/library/littler/examples/install2.r /usr/local/bin/

RUN ln -s /opt/R/${R_VERSION}/lib/R/library/littler/examples/installGithub.r /usr/local/bin/

RUN ln -s /opt/R/${R_VERSION}/lib/R/library/littler/bin/r /usr/local/bin/

RUN R -e "install.packages('TMB', dependencies = TRUE)"

RUN R -e "install.packages('docopt', dependencies = NA)"

RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager')" \
    && R -e "BiocManager::install(c('graph', 'Rgraphviz'), dep=TRUE)"

#RUN R -e "install.packages('INLA',repos=c(getOption('repos'),INLA='https://inla.r-inla-download.org/R/stable'), dep=TRUE,method='wget')"

#ENV RLIB $(Rscript -e '.libPaths()[1]') 

ENV RLIB "/opt/R/${R_VERSION}/lib/R/library"

RUN echo "RLIB=${RLIB}"

ENV REPOSINLA="$(R -e \"c(getOption('repos'),INLA='https://inla.r-inla-download.org/R/stable')\")"

RUN install2.r  --error --ncpus -2 --skipinstalled -l ${RLIB} \
    --repos "${PRPMBIN}" \
     -- --no-staged-install 'ggplot2' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN install2.r  --error --ncpus -2 --skipinstalled -l ${RLIB} \
    --repos "${PRPMBIN}" \
     -- --no-staged-install 'tidyverse' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Set a default user. Available via runtime flag `--user docker` 
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly). 
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN mkdir /scripts &&  chown docker:docker /scripts

COPY testplots.r /scripts

RUN chown docker:docker /scripts/*

############### 

RUN install2.r  --error --ncpus -2 --skipinstalled -l ${RLIB} \
    --repos "${PRPMBIN}" \
     -- --no-staged-install 'devtools' \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

#ARG INLA_REPO='testing'

ARG INLA_REPO='stable'


RUN R -e "install.packages('INLA',repos=c(getOption('repos'),INLA='https://inla.r-inla-download.org/R/${INLA_REPO}'), dep=TRUE,method='wget')"

#RUN install2.r  --error --ncpus -1 --skipinstalled -l ${RLIB} \
#    --repos "${REPOSINLA}" \
#     -- --no-staged-install 'INLA' \
#    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


RUN --mount=type=secret,id=dotenv,dst=/run/secrets/.env \
    set -a && . /run/secrets/.env && set +a \
  && installGithub.r 'james-thorson/FishStatsUtils' \
   'james-thorson/Utilities' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# Install VAST from github
#RUN R -e "remotes::install_github('james-thorson/VAST', INSTALL_opts='--no-staged-install' , auth_token = $GITHUBPASSWORD)"

RUN --mount=type=secret,id=dotenv,dst=/run/secrets/.env set -a \
  && . /run/secrets/.env && set +a \
  && installGithub.r 'james-thorson/VAST' \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

#RUN R -e "install.packages('INLA',repos=c(getOption('repos'),INLA='https://inla.r-inla-download.org/R/testing'), dep=TRUE)"
