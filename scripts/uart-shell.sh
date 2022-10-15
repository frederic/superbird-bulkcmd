#!/bin/bash
DIR=$(dirname $(realpath $0))
UPDTOOL=$DIR/../bin/update

$UPDTOOL bulkcmd 'amlmmc env'
$UPDTOOL bulkcmd 'setenv initargs init=/sbin/pre-init'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} ramoops.pstore_en=1'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} ramoops.record_size=0x8000'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} ramoops.console_size=0x4000'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} rootfstype=ext4'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} console=ttyS0,115200n8'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} no_console_suspend'
$UPDTOOL bulkcmd 'setenv initargs ${initargs} earlycon=aml-uart,0xff803000'
$UPDTOOL bulkcmd 'env save'
