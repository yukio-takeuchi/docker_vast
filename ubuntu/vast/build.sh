#!/bin/bash

if [ $# -lt  1 ]; then
  echo "arguments are missing "
  echo "At least name of log-file is needed"
  echo "In addition addition one option for docker build command in second argument"
  exit 1
fi

LOGFILE=$1

if [ $# -eq 2 ]; then
	BUILDOP=$2
else
  BUILDOP=
fi

NM=yosemite0808/ubuntu_vast

export DOCKER_BUILDKIT=1
# docker build .  --tag $NM:latest $2 \
# --secret id=dotenv,src=.env  2>&1  | tee ${LOGFILE}.log

 docker build . ${BUILDOP}   --tag $NM:latest $2 \
  --secret id=dotenv,src=../../.env  2>&1  | tee ${LOGFILE}.log

#docker build . --tag $NM:latest $2 2>&1  | tee ${LOGFILE}.log
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
docker tag $NM:latest $NM:$(date -d now +%Y%m%d%H%M) 2>&1  | tee -a ${LOGFILE}.log
docker tag $NM:latest $NM:$(date -d now +%Y%m%d) 2>&1  | tee -a ${LOGFILE}.log
if [ -f ${LOGFILE}.log  ]; then
  cp -p ${LOGFILE}.log  ~/Dropbox/vast/log/${LOGFILE}_$(date -d now +%Y%m%d%H%M).log
fi 

# date -d now +%Y%m%d%H%M


