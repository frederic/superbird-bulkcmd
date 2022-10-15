#!/bin/sh
# Extract base files from /system partition required to build an initramdisk.

DIR=$(dirname $(realpath $0))
SYSTEM_DIR=
CPIO_BASE_FILE=$DIR/../images/superbird.initrd-base.cpio

if [ -z "$SYSTEM_DIR" ] || [ ! -d "$SYSTEM_DIR" ]
then
echo 'Error: Set SYSTEM_DIR variable to path of mounted /system partition from the device.'
exit 1
else
cd $SYSTEM_DIR && cat $DIR/initrd.list | cpio --quiet -o -H newc > $CPIO_BASE_FILE
fi