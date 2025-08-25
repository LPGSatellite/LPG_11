#!/bin/bash
verbose=0
if [[ $1 == "-v" ]]; then
    verbose=1
fi
data_to_write=0x00

for addr in $(seq 0x48 0x4F); do
    hex_addr=$(printf "%02X" $addr)
    if [[ $verbose -eq 1 ]]; then
        echo "Writing to address: 0x$hex_addr"
        echo "i2cset -y 0 0x$hex_addr 0x0 $data_to_write"
    fi
    sudo i2cset -y 0 0x$hex_addr 0x0 $data_to_write

    if [ $? -eq 0 ]; then
        echo "Successfully wrote 0x$data_to_write to 0x$hex_addr"
    else
        echo "Failed to write 0x$data_to_write to 0x$hex_addr"
    fi

    echo
done
