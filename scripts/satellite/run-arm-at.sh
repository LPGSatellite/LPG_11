#!/bin/bash

mkdir -p /home/user/output/19/mount-testlogs
Timestamp=$(date +%Y%m%d%H%M%S)

log_file=/home/user/output/19/arm-at-${Timestamp}.log

docker run --rm \
    -v /home/user/output/19/mount-testlogs:/root/anonymous-tokens/testlogs \
    -v /home/user/experiment/19/run-arm-at-internal.sh:/root/anonymous-tokens/run.sh \
    -it arm-at bash run.sh > $log_file

