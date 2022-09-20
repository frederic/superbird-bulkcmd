# [superbird-bulkcmd](https://github.com/frederic/superbird-bulkcmd)

[Spotify Car Thing](https://carthing.spotify.com/) (superbird) resources to access U-Boot shell over USB. No bug exploited, it's a feature.

*Note: this method has been tested on the factory firmware (device never used/updated).*

## Disclaimer
You are solely responsible for any damage caused to your hardware/software/keys/DRM licences/warranty/data/cat/etc...

## Files
- update : [Khadas tool](https://github.com/khadas/utils/blob/master/aml-flash-tool/tools/linux-x86/update)
- superbird.bl2.encrypted.bin : BL2 image from factory firmware
- superbird.bootloader.img : bootloader image from factory firmware

## U-Boot shell over USB (USB burning mode):
Hold buttons 1 & 4 while booting target. A new USB device appears on host side :
```
usb 1-1: New USB device found, idVendor=1b8e, idProduct=c003, bcdDevice= 0.20
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: GX-CHIP
usb 1-1: Manufacturer: Amlogic
```
Execute the following commands to load U-Boot over USB :
```shell
./update write ./superbird.bl2.encrypted.bin 0xfffa0000
./update run 0xfffa0000
./update bl2_boot ./superbird.bootloader.img
```
A new USB device appears on host side :
```
usb 1-1: New USB device found, idVendor=1b8e, idProduct=c003, bcdDevice= 0.07
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
````
The target is now in USB burning mode (implemented in U-Boot).

## Dump EMMC over USB
In U-Boot burning mode :
```shell
./update bulkcmd 'amlmmc part 1'
./update mread store bootloader normal 0x400000 bootloader.dump
./update mread store env normal 0x800000 env.dump
./update mread store fip_a normal 0x400000 fip_a.dump
./update mread store fip_b normal 0x400000 fip_b.dump
./update mread store logo normal 0x800000 logo.dump
./update mread store dtbo_a normal 0x400000 dtbo_a.dump
./update mread store dtbo_b normal 0x400000 dtbo_b.dump
./update mread store vbmeta_a normal 0x100000 vbmeta_a.dump
./update mread store vbmeta_b normal 0x100000 vbmeta_b.dump
./update mread store boot_a normal 0x1000000 boot_a.dump
./update mread store boot_b normal 0x1000000 boot_b.dump
./update mread store misc normal 0x800000 misc.dump
./update mread store settings normal 0x10000000 settings.dump
./update mread store system_a normal 0x2040B000 system_a.dump
./update mread store system_b normal 0x2040B000 system_b.dump
./update mread store data normal 0x889EA000 data.dump
```

## Update *env* to enable Linux root shell over UART
*Note: Access to UART port requires to open the device.*

In U-Boot burning mode :
```shell
./update bulkcmd 'amlmmc env'
./update bulkcmd 'setenv initargs init=/sbin/pre-init'
./update bulkcmd 'setenv initargs ${initargs} ramoops.pstore_en=1'
./update bulkcmd 'setenv initargs ${initargs} ramoops.record_size=0x8000'
./update bulkcmd 'setenv initargs ${initargs} ramoops.console_size=0x4000'
./update bulkcmd 'setenv initargs ${initargs} rootfstype=ext4'
./update bulkcmd 'setenv initargs ${initargs} console=ttyS0,115200n8'
./update bulkcmd 'setenv initargs ${initargs} no_console_suspend'
./update bulkcmd 'setenv initargs ${initargs} earlycon=aml-uart,0xff803000'
./update bulkcmd 'env save'
```

## Disable AVB2 & dm-verity
Define *system_b* (/dev/mmcblk0p15) as root for Kernel (change to /dev/mmcblk0p14 for *system_a*).
```shell
./update bulkcmd 'amlmmc env'
./update bulkcmd 'setenv storeargs ${storeargs} setenv avb2 0\;'
./update bulkcmd 'setenv initargs ${initargs} ro root=/dev/mmcblk0p15'
./update bulkcmd 'env save'
```