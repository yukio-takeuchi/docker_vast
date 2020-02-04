#!/bin/bash

if [ $# != 1 ]; then
  echo "number of arguments differ from 1!"
  exit 1
fi

LOGFILE=$1

NM=yosemite0808/r-base_fromofficial_vast

docker build . --tag $NM:latest | tee $LOGFILE
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
docker tag $NM:latest $NM:$(date -d now +%Y%m%d) | tee -a $LOGFILE

if [ -f $LOGFILE  ]; then
  cp -p $LOGFILE ~/Dropbox/vast/log/
fi

