#!/bin/sh
vmdebootstrap \
    --arch armhf \
    --distribution parrot \
    --mirror http://[::1]:3142/archive.parrotsec.org/parrot \
    --image `date +Parrot-%y%m%d_armhf.img` \
    --size 7400M \
    --bootsize 64M \
    --boottype vfat \
    --root-password toor \
    --enable-dhcp \
    --verbose \
    --no-kernel \
    --no-extlinux \
    --hostname parrot-iot \
    --foreign /usr/bin/qemu-arm-static \
    --debootstrapopts="variant=minbase keyring=`pwd`/raspbian.org.gpg" \
    --customize `pwd`/postinstall.sh
