#!/bin/bash
docker run -it --rm --name ubuntu-vast-test-run -v ${PWD}:/home/docker --user docker  ubuntu-vast-test  /bin/bash

