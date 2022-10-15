#!/bin/bash
DIR=$(dirname "$(realpath "$0")")
UPDTOOL=$DIR/../bin/update

mkdir -p $DIR/dump
$UPDTOOL bulkcmd "amlmmc part 1"
$UPDTOOL mread store bootloader normal 0x400000 dump/bootloader.dump
$UPDTOOL mread store env normal 0x800000 dump/env.dump
$UPDTOOL mread store fip_a normal 0x400000 dump/fip_a.dump
$UPDTOOL mread store fip_b normal 0x400000 dump/fip_b.dump
$UPDTOOL mread store logo normal 0x800000 dump/logo.dump
$UPDTOOL mread store dtbo_a normal 0x400000 dump/dtbo_a.dump
$UPDTOOL mread store dtbo_b normal 0x400000 dump/dtbo_b.dump
$UPDTOOL mread store vbmeta_a normal 0x100000 dump/vbmeta_a.dump
$UPDTOOL mread store vbmeta_b normal 0x100000 dump/vbmeta_b.dump
$UPDTOOL mread store boot_a normal 0x1000000 dump/boot_a.dump
$UPDTOOL mread store boot_b normal 0x1000000 dump/boot_b.dump
$UPDTOOL mread store misc normal 0x800000 dump/misc.dump
$UPDTOOL mread store settings normal 0x10000000 dump/settings.dump
$UPDTOOL mread store system_a normal 0x2040B000 dump/system_a.dump
$UPDTOOL mread store system_b normal 0x2040B000 dump/system_b.dump
$UPDTOOL mread store data normal 0x889EA000 dump/data.dump
