# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Shag Kernel for Bonito/Sargo
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=sargo
device.name2=bonito
supported.versions=10
supported.patchlevels=
'; } # end properties

# shell variables
block=boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


decompressed_image=/tmp/anykernel/Image
compressed_image=$decompressed_image.lz4
if [ -f $compressed_image ]; then
  # Hexpatch the kernel if Magisk is installed ('skip_initramfs' -> 'want_initramfs')
  if [ -d $ramdisk/.backup ]; then
    ui_print " "; ui_print "Magisk detected! Patching kernel so reflashing Magisk is not necessary...";
    $bin/magiskboot --decompress $compressed_image $decompressed_image;
    $bin/magiskboot --hexpatch $decompressed_image 736B69705F696E697472616D667300 77616E745F696E697472616D667300;
    $bin/magiskboot --compress=lz4 $decompressed_image $compressed_image;
  fi;
  # Concatenate all of the dtbs to the kernel
  # cat $compressed_image /tmp/anykernel/dtbs/*.dtb > /tmp/anykernel/Image.lz4-dtb;
fi;


## AnyKernel install
dump_boot;
write_boot;
