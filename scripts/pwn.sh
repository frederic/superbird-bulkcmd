#!/bin/bash
DIR=$(dirname "$(realpath "$0")")
mkdir -p $DIR/dump
sudo update write $DIR/../images/superbird.bl2.encrypted.bin 0xfffa0000
sudo update run 0xfffa0000
sudo update bl2_boot $DIR/../images/superbird.bootloader.img
