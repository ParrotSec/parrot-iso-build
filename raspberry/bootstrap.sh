#!/bin/bash

SOURCEDIR=$(dirname $0)

vmdebootstrap \
    --arch armhf \
    --distribution stable \
    --mirror http://deb.parrotsec.org/parrot \
    --image `date +parrot-rpi-%Y%m%d.img` \
    --size 8120M \
    --bootsize 64M \
    --boottype vfat \
    --root-password toor \
    --verbose \
    --no-kernel \
    --no-extlinux \
    --hostname parrot \
    --foreign /usr/bin/qemu-arm-static \
    --debootstrapopts="keyring=$SOURCEDIR/parrotsec.gpg verbose" \
    --package="gnupg2 dirmngr ca-certificates" \
    --customize "$SOURCEDIR/customize.sh" \
    --log-level="debug"
