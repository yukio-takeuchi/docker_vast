#!/bin/bash

docker build  --secret id=dotenv,src=./.env .  -t $1
