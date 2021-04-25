#!/bin/bash
docker run -it --rm --name ubuntu-jp-test -v ${PWD}:/home/docker --user docker  ubuntu-jp  /bin/bash

