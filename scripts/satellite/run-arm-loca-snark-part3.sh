#!/bin/bash

# Define N and K pairs
pairs=(
  "512 32"
) 

# Iterate over pairs and run the command
for pair in "${pairs[@]}"; do
  # Parse N and K
  N=$(echo $pair | awk '{print $1}')
  K=$(echo $pair | awk '{print $2}')

  # Generate timestamp
  Timestamp=$(date +%Y%m%d%H%M%S)

  # Run Docker command and redirect output to log file
  log_file=/home/user/output/19/arm-loca-snark-${N}-${K}-${Timestamp}.log
  echo "Running: docker run -it arm-loca-snark bash run.sh $N $K 100 > $log_file"
  docker run --rm -it arm-loca-snark bash run.sh $N $K 100 > $log_file

done
