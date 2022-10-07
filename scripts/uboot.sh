#!/bin/sh
# Boot U-Boot in 'USB Burning' mode
DIR=$(dirname $(realpath $0))
UPDTOOL=$DIR/../bin/update

$UPDTOOL write $DIR/../images/superbird.bl2.encrypted.bin 0xfffa0000
$UPDTOOL run 0xfffa0000
$UPDTOOL bl2_boot $DIR/../images/superbird.bootloader.img
