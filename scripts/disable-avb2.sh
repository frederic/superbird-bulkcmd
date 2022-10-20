#!/bin/sh
# Disable AVB2 & dm-verity
# Define system_b (/dev/mmcblk0p15) as root partition (change to /dev/mmcblk0p14 for system_a).
# WARNING : This disables A/B boot mechanism.

DIR=$(dirname $(realpath $0))
UPDTOOL=$DIR/../bin/update

$UPDTOOL bulkcmd 'amlmmc env'
$UPDTOOL bulkcmd 'setenv storeargs ${storeargs} setenv avb2 0\;'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} ro root=/dev/mmcblk0p15'
$UPDTOOL bulkcmd 'env save'