# [superbird-bulkcmd](https://github.com/frederic/superbird-bulkcmd)

[Spotify Car Thing](https://carthing.spotify.com/) (superbird) resources to access U-Boot shell over USB. No bug exploited, not a bug, it is a ["feature"](https://miro.medium.com/max/1200/1*KDfUqn6c66axcbsTPPWSpQ.jpeg).

*Note: this method has been tested on the factory firmware (device never used/updated).*

## Disclaimer
You are solely responsible for any damage caused to your hardware/software/keys/DRM licences/warranty/data/cat/etc...

## Requirements
- A Car Thing (superbird) without USB password
- Either a USB A to C, or a C to C cable
- A PC running some flavor of 64-bit GNU Linux
- `libusb-dev` installed

## FAQ
Does this process void my warranty on this device?
- Probably, assume so.                                                                                              
Can I OTA afterwards?
- NO - DM-Verity is disabled, and on-device partitions modified, OTA updates will fail, though given this device is EOL, we don't expect further OTA updates.
Can I use stock?
- Yes! Perfectly normal and usable, this just enables root access and ADB.
Can I go back to stock after installing custom OS's or messing up the stock image?
- Yes! - **WIP**

## Files
- /bin/: prebuilt set of required tools
  - [update](https://github.com/khadas/utils/blob/master/aml-flash-tool/tools/linux-x86/update): Client for the USB Burning protocol implemented in Amlogic bootloaders
- /bootloader/: prebuilt bootloader image to upload via USB
  - superbird.bl2.encrypted.bin: BL2
  - superbird.bootloader.img: BL3x, DDR, etc. 
- /scripts/: Scripts used to simplify interacting with the devices

# Guide
1. Unplug the Car Thing from everything
2. Clone/Download this repo locally, and change your shell's directory to it & ensure you `libusb-dev` installed
3. Hold buttons 1 & 4 on the case, and plug the Car Thing into your PC via USB

The host should see a new USB device connection in `dmesg` like this one:
```text
usb 1-1: New USB device found, idVendor=1b8e, idProduct=c003, bcdDevice= 0.20
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: GX-CHIP
usb 1-1: Manufacturer: Amlogic
```
4. Release the button once this device has been detected by host computer.
5. Execute script **root&#46;sh** to load and follow the instructions it provides.

## Technical Explanation of the Process

### [BootROM] U-Boot shell over USB (USB burning mode):
Execute the following commands to load U-Boot over USB :
```
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

### [U-Boot] Dump EMMC over USB
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

### [U-Boot] Update *env* to enable Linux root shell over UART
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

### [U-Boot] Disable AVB2 & dm-verity
Define *system_b* (/dev/mmcblk0p15) as root for Kernel (change to /dev/mmcblk0p14 for *system_a*).
```shell
./update bulkcmd 'amlmmc env'
./update bulkcmd 'setenv storeargs ${storeargs} setenv avb2 0\;'
./update bulkcmd 'setenv initargs ${initargs} ro root=/dev/mmcblk0p15'
./update bulkcmd 'env save'
```

### [Linux] Enable ADB over USB
```shell
mkdir /dev/usb-ffs
mkdir /dev/usb-ffs/adb
mount -t configfs none /sys/kernel/config/
mkdir /sys/kernel/config/usb_gadget/g1
echo 0x18d1 > /sys/kernel/config/usb_gadget/g1/idVendor
echo 0x4e40 > /sys/kernel/config/usb_gadget/g1/idProduct
echo 0x0223 > /sys/kernel/config/usb_gadget/g1/bcdDevice
echo 0x0200 > /sys/kernel/config/usb_gadget/g1/bcdUSB
mkdir /sys/kernel/config/usb_gadget/g1/strings/0x409
echo 123456 > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
echo Spotify > /sys/kernel/config/usb_gadget/g1/strings/0x409/manufacturer
echo Superbird > /sys/kernel/config/usb_gadget/g1/strings/0x409/product
mkdir /sys/kernel/config/usb_gadget/g1/functions/ffs.adb
mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1
mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409
echo 500 > /sys/kernel/config/usb_gadget/g1/configs/b.1/MaxPower
mount -t functionfs adb /dev/usb-ffs/adb
ln -s /sys/kernel/config/usb_gadget/g1/configs/b.1 /sys/kernel/config/usb_gadget/g1/os_desc/b.1
echo adb > /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration 
ln -s /sys/kernel/config/usb_gadget/g1/functions/ffs.adb /sys/kernel/config/usb_gadget/g1/configs/b.1/f1
/usr/bin/adbd &
sleep 3s
echo ff400000.dwc2_a > /sys/kernel/config/usb_gadget/g1/UDC
```

## Credits
- Frederic Basse (frederic)/Nolen Johnson (npjohnson): The writeup, helping debug/develop/theorize the methodologies used
- Sean Hoyt (deadman): The awesome hacked-logo image.

## Relevant Device Soruce Code
- U-Boot: [superbird-uboot](https://github.com/spsgsb/uboot/tree/buildroot-openlinux-201904-g12a)
- GNU/Linux: [superbird-linux](https://github.com/spsgsb/kernel-common)
