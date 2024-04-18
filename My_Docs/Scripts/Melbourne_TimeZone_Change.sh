#!/bin/bash

current_date=$(date +"%Y-%m-%d")
if [ "$(date -d "$current_date" +'%m-%d')" == "10-01" ]; then
    timedatectl set-timezone Australia/Sydney
fi

if [ "$(date -d "$current_date" +'%m-%d')" == "04-01" ]; then
    timedatectl set-timezone Australia/Sydney
fi

## Add the crojob to run on 1st day every min of October and April months
## * * 1 10,4 /path/to/script/file.sh

