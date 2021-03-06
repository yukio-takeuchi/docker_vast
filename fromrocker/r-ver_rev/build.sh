#!/bin/bash

if [ $# -lt  1 ]; then
  echo "number of arguments differ from 1!"
  echo "At least name of log-file is needed"
  echo "In addition addition one option for docker build command in second argument"
  exit 1
fi

LOGFILE=$1
#
# Install VAST on rocker/r-ver R installed on debian.stable
#
NM=yosemite0808/r-ver_vast

docker build .     --build-arg github_password=$PERSONAL_ACCESS_TOKEN \
 --tag $NM:latest $2  | tee ${LOGFILE}.log
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
if [ $(uname)='Darwin' ]; then 
  DATE="$(date  +%Y%m%d)"
  DATETIME="$(date  +%Y%m%d%H%M)"
else
  DATE="$(date -d now +%Y%m%d)" 
  DATETIME="$(date -d now +%Y%m%d%H%M)"
fi
echo "DATETIME is $DATETIME"
docker tag $NM:latest $NM:rev_$DATE | tee -a ${LOGFILE}.log
if [ -f ${LOGFILE}.log  ]; then
  cp -p ${LOGFILE}.log  ~/Dropbox/vast/log/${LOGFILE}_$DATETIME.log
fi 

# date -d now +%Y%m%d%H%M


