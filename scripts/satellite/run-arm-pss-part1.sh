#!/bin/bash

# Define argument seqs
seqs=(
  "2748779069441 16 40 1024 1 1"
  "2748779069441 32 0 1024 1 1"
  "2748779069441 32 10 1024 1 1"
  "2748779069441 32 20 1024 1 1"
  "2748779069441 32 30 1024 1 1"
  "2748779069441 32 40 1024 1 1"
  "2748779069441 64 0 1024 1 1"
  "2748779069441 64 10 1024 1 1"
  "2748779069441 64 20 1024 1 1"
  "2748779069441 64 30 1024 1 1"
  "2748779069441 64 40 1024 1 1"
  "2748779069441 16 0 2048 1 1"
  "2748779069441 16 10 2048 1 1"
  "2748779069441 16 20 2048 1 1"
  "2748779069441 16 30 2048 1 1"
  "2748779069441 16 40 2048 1 1"
  "2748779069441 32 0 2048 1 1"
  "2748779069441 32 10 2048 1 1"
  "2748779069441 32 20 2048 1 1"
  "2748779069441 32 30 2048 1 1"
  "2748779069441 32 40 2048 1 1"
  "2748779069441 64 0 2048 1 1"
  "2748779069441 64 10 2048 1 1"
  "2748779069441 64 20 2048 1 1"
  "2748779069441 64 30 2048 1 1"
  "2748779069441 64 40 2048 1 1"
)

# docker run -it arm-pss bash run.sh 2748779069441 64 32 4096 1 0.1

 
# Iterate over pairs and run the command
for seq in "${seqs[@]}"; do
  # Parse N and K
  field_size=$(echo $seq | awk '{print $1}')
  l=$(echo $seq | awk '{print $2}')
  t=$(echo $seq | awk '{print $3}')
  num_parties=$(echo $seq | awk '{print $4}')
  Num_repeats=$(echo $seq | awk '{print $5}')
  sleep_time_ms=$(echo $seq | awk '{print $6}')

  # Generate timestamp
  Timestamp=$(date +%Y%m%d%H%M%S)

  # Run Docker command and redirect output to log file
  log_file=/home/user/output/19/arm-pss-${field_size}-${l}-${t}-${num_parties}-${Num_repeats}-${sleep_time_ms}-${Timestamp}.log
  echo "Running: docker run -it arm-pss bash run.sh ${field_size} ${l} ${t} ${num_parties} ${Num_repeats} ${sleep_time_ms} > $log_file"
  docker run -it arm-pss bash run.sh ${field_size} ${l} ${t} ${num_parties} ${Num_repeats} ${sleep_time_ms} > $log_file

done
