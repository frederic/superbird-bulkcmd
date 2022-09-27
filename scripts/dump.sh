#!/bin/bash
DIR=$(dirname "$(realpath "$0")")
mkdir -p $DIR/dump
sudo update bulkcmd "amlmmc part 1"
sudo update mread store bootloader normal 0x400000 dump/bootloader.dump
sudo update mread store env normal 0x800000 dump/env.dump
sudo update mread store fip_a normal 0x400000 dump/fip_a.dump
sudo update mread store fip_b normal 0x400000 dump/fip_b.dump
sudo update mread store logo normal 0x800000 dump/logo.dump
sudo update mread store dtbo_a normal 0x400000 dump/dtbo_a.dump
sudo update mread store dtbo_b normal 0x400000 dump/dtbo_b.dump
sudo update mread store vbmeta_a normal 0x100000 dump/vbmeta_a.dump
sudo update mread store vbmeta_b normal 0x100000 dump/vbmeta_b.dump
sudo update mread store boot_a normal 0x1000000 dump/boot_a.dump
sudo update mread store boot_b normal 0x1000000 dump/boot_b.dump
sudo update mread store misc normal 0x800000 dump/misc.dump
sudo update mread store settings normal 0x10000000 dump/settings.dump
sudo update mread store system_a normal 0x2040B000 dump/system_a.dump
sudo update mread store system_b normal 0x2040B000 dump/system_b.dump
sudo update mread store data normal 0x889EA000 dump/data.dump
