#!/bin/bash

if [ $# != 1 ]; then
  echo "number of arguments differ from 1!"
  exit 1
fi

LOGFILE=$1

NM=yosemite0808/ubuntu_vast

docker build . --tag $NM:latest | tee ${LOGFILE}.log
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
docker tag $NM:latest $NM:$(date -d now +%Y%m%d) | tee -a ${LOGFILE}.log
if [ -f ${LOGFILE}.log  ]; then
  cp -p ${LOGFILE}.log  ~/Dropbox/vast/log/${LOGFILE}_$(date -d now +%Y%m%d%H%M).log
fi 

# date -d now +%Y%m%d%H%M


