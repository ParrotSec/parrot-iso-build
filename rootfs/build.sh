#!/bin/bash
VERSION=$1
function bootstrap {
	ARCH=$1
	EDITION=parrot
	echo "Building $EDITION-$ARCH"
	rm -r $EDITION-$ARCH/ || true
	debootstrap --arch=$ARCH --components=main,contrib,non-free --include=gnupg2,nano,base-files,parrot-core $EDITION $EDITION-$ARCH https://deb.parrot.sh/direct/parrot/
	rm -rf $EDITION-$ARCH/var/cache/apt/* $EDITION-$ARCH/var/lib/apt/lists/*
	echo "Customizing $EDITION-$ARCH"
	echo "Done $EDITION-$ARCH"
}


mkdir -p images
for arch in amd64 i386 arm64 armhf; do
    bootstrap $arch
    tar cvf - parrot-$arch | xz -q -c --best --extreme - > images/Parrot-rootfs-${VERSION}_$arch.tar.xz
done


for ARCH in arm64 armhf; do
    debootstrap --arch=$ARCH --components=main,contrib,non-free --include=gnupg2,nano,base-files parrot parrot-$ARCH https://deb.parrot.sh/direct/parrot/

    mount --bind /dev parrot-$ARCH/dev
    mount --bind /proc parrot-$ARCH/proc
    mount --bind /sys parrot-$ARCH/sys
    mount --bind /run parrot-$ARCH/run

    export DEBIAN_FRONTEND=noninteractive
    chroot parrot-$ARCH -- apt update
    chroot parrot-$ARCH -- apt -y install parrot-core
    chroot parrot-$ARCH -- apt update
    chroot parrot-$ARCH -- apt -y install ca-certificates pciutils usbutils iw mdadm parted bash-completion rng-tools5 haveged inxi neofetch htop nload iftop
    chroot parrot-$ARCH -- apt -y install openssh-server sudo network-manager cloud-guest-utils firmware-brcm80211 raspi-config
    if [ $ARCH == "arm64" ]; then
        chroot parrot-$ARCH -- apt -y install raspberrypi-kernel raspberrypi-kernel-headers raspberrypi-bootloader raspi3-firmware
    fi
    if [ $ARCH == "armhf" ]; then
        chroot parrot-$ARCH -- apt -y install raspberrypi-kernel raspberrypi-kernel-headers raspberrypi-bootloader raspi-firmware
    fi
    chroot parrot-$ARCH -- apt -y install parrot-desktop-mate chromium- mate-user-guide- pocketsphinx-en-us- libreoffice-help-en-us- mythes-en-us- libreoffice-help-common- espeak-ng-data-
done


rm -rf $EDITION-$ARCH/var/cache/apt/* $EDITION-$ARCH/var/lib/apt/lists/*
