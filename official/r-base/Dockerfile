FROM r-base

## In order to avoid interupt for timezone setting
ENV DEBIAN_FRONTEND=noninteractive 

## This command is taken from https://raw.githubusercontent.com/egonzalf/rstudio-inla/master/Dockerfile 
## Then modified to add additional packages for instlation of rgl
RUN apt-get update && \
    apt-get -y install --no-install-recommends --allow-downgrades \
#        build-essential \
#        gcc g++ gfortran \
        libfreetype-dev \
        libgdal-dev \
        libglu1-mesa-dev \
	libgl1-mesa-dev \
	libglvnd-dev \
	libx11-dev \
	#libxcb1=1.13.1-2 \
	libxcb1 \
	libxcb1-dev \
	libssl-dev \
	libgl-dev \
	libglx-dev \
        mesa-common-dev \
	xserver-xorg-core \
 	xserver-xorg-video-dummy \
	libudunits2-dev \
	libftgl-dev  \
	libgl1-mesa-dev \
        libgit2-dev \
	libssh2-1-dev \
	file \
	&& apt-get autoremove -y && apt-get autoclean -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* 


#  libgl1-mesa-dev : Depends: libglvnd-dev but it is not going to be installed
#  libglx-dev : Depends: libx11-dev but it is not going to be installed
#   mesa-common-dev : Depends: libx11-dev but it is not going to be installed

# libftgl-dev : Depends: libgl1-mesa-dev but it is not going to be installed or
#                        libgl-dev but it is not going to be installed
# libglu1-mesa-dev : Depends: libgl1-mesa-dev but it is not going to be installed or
#                             libgl-dev but it is not going to be installed
# mesa-common-dev : Depends: libgl-dev but it is not going to be installed
#                   Depends: libglx-dev but it is not going to be installed
#                   Depends: libx11-dev but it is not going to be installed
# bx11-dev : Depends: libxcb1-dev but it is not going to be installed

## Avoid error related to rgl package on headless see https://github.com/r-lib/remotes/issues/332 
ENV RGL_USE_NULL  "TRUE"

RUN R -e "options(repos = c('https://cloud.r-project.org/')); \
    update.packages(ask=FALSE)"

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

