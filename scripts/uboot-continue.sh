#!/bin/sh
# Exit U-Boot 'USB Burning' mode and continue default boot
DIR=$(dirname $(realpath $0))
UPDTOOL=$DIR/../bin/update

$UPDTOOL bulkcmd 'mw.b 0x17f89754 1'
