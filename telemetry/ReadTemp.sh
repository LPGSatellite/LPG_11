#!/bin/bash
verbose=0
if [[ $1 == "-v" ]]; then
    verbose=1
fi
if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

for addr in $(seq 0x48 0x4F); do
    hex_addr=$(printf "%02X" $addr)
    if [[ $verbose -eq 1 ]]; then
    echo "Reading from address: 0x$hex_addr"
    echo "i2cget -y 0 0x$hex_addr 0x00 w"
    fi
    input_data=$(i2cget -y 0 0x$hex_addr 0x00 w)

    decimal_data=$((input_data))

    low_byte=$(( (decimal_data & 0xFF00) >> 8 ))
    high_byte=$(( (decimal_data & 0x00FF) << 8 ))
    little_endian=$(( low_byte | high_byte ))

    shifted_data=$(( little_endian >> 4 ))

    final_result=$(echo "scale=4; $shifted_data * 0.0625" | bc)

    echo "Address 0x$hex_addr temperature: $final_result"
done
