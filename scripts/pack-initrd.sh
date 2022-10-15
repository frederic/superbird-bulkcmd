#!/bin/sh
# Pack the initrd image using base CPIO archive plus additional files from initrd/ directory
# mkimage tool is available in Debian package u-boot-tools
DIR=$(dirname $(realpath $0))
INITRD_DIR=$DIR/../initrd
CPIO_BASE_FILE=$DIR/../images/superbird.initrd-base.cpio
CPIO_FILE=$DIR/../images/superbird.initrd.cpio
INITRD_FILE=$DIR/../images/superbird.initrd.img

if [ ! -f "$CPIO_BASE_FILE" ]
then
echo "Error: File $CPIO_BASE_FILE must be extracted first using extract-cpio.sh script !"
exit 1
fi

mkdir -p $INITRD_DIR/dev
sudo mknod -m 0622 $INITRD_DIR/dev/console c 5 1

cp $CPIO_BASE_FILE $CPIO_FILE
cd $INITRD_DIR && find . | cpio -o -H newc --append -F $CPIO_FILE
cd -
gzip $CPIO_FILE
mkimage -n uInitrd -A arm64 -O linux -T ramdisk -C gzip -d $CPIO_FILE.gz $INITRD_FILE