#!/bin/bash

docker build . --tag yosemite0808/r_base_vast:latest
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
#docker tag yosemite0808/r_base_vast:latest yosemite0808/r_base_vast:$(date -d now +%Y%m%d)

