#!/bin/bash

if [ $# != 1 ]; then
   echo "number of arguments differ from 1!"
    exit 1
fi

LOGFILE=$1

docker build . --tag yosemite0808/ubuntu_vast:latest | tee $1
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
docker tag yosemite0808/ubuntu_vast:latest yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d) | tee -a $1 
if [ -f $1  ]; then
  cp -p $1 ~/Dropbox/vast/log/
fi 

