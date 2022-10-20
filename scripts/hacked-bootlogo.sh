#!/bin/bash
DIR=$(dirname "$(realpath "$0")")
UPDTOOL=$DIR/../bin/update

$UPDTOOL bulkcmd "amlmmc part 1"
$UPDTOOL partition logo $DIR/../images/hacked_logo.img
