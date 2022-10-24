#!/bin/bash
DIR=$(dirname "$(realpath "$0")")
UPDTOOL=$DIR/../bin/update

OUTPATH="$DIR/../dump"
mkdir -p "$OUTPATH"

$UPDTOOL bulkcmd "amlmmc part 1"
$UPDTOOL mread store bootloader normal 0x400000 "$OUTPATH/bootloader.dump"
$UPDTOOL mread store env normal 0x800000 "$OUTPATH/env.dump"
$UPDTOOL mread store fip_a normal 0x400000 "$OUTPATH/fip_a.dump"
$UPDTOOL mread store fip_b normal 0x400000 "$OUTPATH/fip_b.dump"
$UPDTOOL mread store logo normal 0x800000 "$OUTPATH/logo.dump"
$UPDTOOL mread store dtbo_a normal 0x400000 "$OUTPATH/dtbo_a.dump"
$UPDTOOL mread store dtbo_b normal 0x400000 "$OUTPATH/dtbo_b.dump"
$UPDTOOL mread store vbmeta_a normal 0x100000 "$OUTPATH/vbmeta_a.dump"
$UPDTOOL mread store vbmeta_b normal 0x100000 "$OUTPATH/vbmeta_b.dump"
$UPDTOOL mread store boot_a normal 0x1000000 "$OUTPATH/boot_a.dump"
$UPDTOOL mread store boot_b normal 0x1000000 "$OUTPATH/boot_b.dump"
$UPDTOOL mread store misc normal 0x800000 "$OUTPATH/misc.dump"
$UPDTOOL mread store settings normal 0x10000000 "$OUTPATH/settings.dump"
$UPDTOOL mread store system_a normal 0x2040B000 "$OUTPATH/system_a.dump"
$UPDTOOL mread store system_b normal 0x2040B000 "$OUTPATH/system_b.dump"
$UPDTOOL mread store data normal 0x889EA000 "$OUTPATH/data.dump" # if this command fails, try 0x859EA000 instead. Thanks bishopdynamics (issue #2 @ GitHub)
