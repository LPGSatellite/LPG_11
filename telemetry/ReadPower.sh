#! /bin/bash

cpu_voltage_raw=$(sudo i2cget -y 1 0x41 0x02 w)

cpu_voltage_hex_le=$(echo $cpu_voltage_raw | awk '{print toupper(substr($1,5,2) substr($1,3,2))}')

cpu_voltage=$(echo "ibase=16; $cpu_voltage_hex_le" | bc)
cpu_voltage=$(echo  "scale=4; $cpu_voltage * 1.25 / 1000" | bc)

echo "CPU Voltage: $cpu_voltage V"

cpu_current_raw=$(sudo i2cget -y 1 0x41 0x04 w)

cpu_current_hex_le=$(echo $cpu_current_raw | awk '{print toupper(substr($1,5,2) substr($1,3,2))}')

cpu_current=$(echo "ibase=16; $cpu_current_hex_le" | bc)
cpu_current=$(echo "scale=6; $cpu_current * 200 / 1000 / 1000" | bc)
echo "CPU Current: $cpu_current A"
cpu_power=$(echo "$cpu_current * $cpu_voltage" | bc)
echo "CPU Power: $cpu_power W"
total_voltage_raw=$(sudo i2cget -y 1 0x40 0x02 w)

total_voltage_hex_le=$(echo $total_voltage_raw | awk '{print toupper(substr($1,5,2) substr($1,3,2))}')

total_voltage=$(echo "ibase=16; $total_voltage_hex_le" | bc)
total_voltage=$(echo  "scale=4; $total_voltage * 1.25 / 1000" | bc)

echo "Total Voltage: $total_voltage V"

total_current_raw=$(sudo i2cget -y 1 0x40 0x04 w)

total_current_hex_le=$(echo $total_current_raw | awk '{print toupper(substr($1,5,2) substr($1,3,2))}')

total_current=$(echo "ibase=16; $total_current_hex_le" | bc)
total_current=$(echo "scale=6; $total_current * 200 / 1000 / 1000" | bc)
echo "Total Current: $total_current A"
total_power=$(echo "$total_current * $total_voltage" | bc)
echo "Total Power: $total_power W"
