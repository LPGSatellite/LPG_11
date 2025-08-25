output_dir="/home/user/output/19"
start_timestamp=$(date "+%Y%m%d-%H%M%S.%3N")
log_file="${output_dir}/${start_timestamp}-temp-power.log"

bash /home/user/configure_i2c.sh

while true; do
  timestamp=$(date "+%Y-%m-%d %H:%M:%S.%3N")
  echo "[$timestamp] thermal" >> "$log_file"
  bash /home/user/read_temp.sh >> "$log_file"
  echo "[$timestamp] power" >> "$log_file"
  bash /home/user/read_power.sh >> "$log_file"
  sleep 0.05
done