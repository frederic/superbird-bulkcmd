#!/bin/sh
# Upload & boot kernel/ramdisk when U-Boot is in 'USB Burning' mode
DIR=$(dirname $(realpath $0))
UPDTOOL=$DIR/../bin/update
KERNEL=$DIR/../images/superbird.kernel.img
KERNEL_ADDR=0x01080000
INITRD=$DIR/../images/superbird.initrd.img # bin/mkimage -n uInitrd -A arm -O linux -T ramdisk -C gzip -d ./initrd.img uInitrd
INITRD_ADDR=0x13000000
ENV=$DIR/env.txt
ENV_ADDR=0x13000000

$UPDTOOL bulkcmd "amlmmc env"
$UPDTOOL write $ENV $ENV_ADDR
$UPDTOOL bulkcmd "env import -t $ENV_ADDR"
$UPDTOOL write $KERNEL $KERNEL_ADDR
$UPDTOOL write $INITRD $INITRD_ADDR
echo 'Booting...'
$UPDTOOL bulkcmd "booti $KERNEL_ADDR $INITRD_ADDR $DTB_ADDR"