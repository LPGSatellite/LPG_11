#!/bin/bash
sudo i2cset -y 1 0x40 0x05 0x0032 w

if [ $? -eq 0 ]; then
    echo "Successfully wrote 0x0032 to register 0x05 in addr 0x40"
else
    echo "Failed to wrote 0x0032 to register 0x05 in addr 0x40"
fi
sudo i2cset -y 1 0x41 0x05 0x0032 w
if [ $? -eq 0 ]; then
    echo "Successfully wrote 0x0032 to register 0x05 in addr 0x41"
else
    echo "Failed to wrote 0x0032 to register 0x05 in addr 0x41"
fi
