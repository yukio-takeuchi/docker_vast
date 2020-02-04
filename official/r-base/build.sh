#!/bin/bash

docker build . --tag yosemite0808/r-base_fromofficial_vast:latest
# docker build . --tag yosemite0808/ubuntu_vast:$(date -d now +%Y%m%d)
docker tag yosemite0808/r-base_fromofficial_vast:latest yosemite0808/r-base_from_official_vast:$(date -d now +%Y%m%d)

