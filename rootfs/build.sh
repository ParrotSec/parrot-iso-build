#!/bin/bash
VERSION=$1
function bootstrap {
	ARCH=$1
	EDITION=parrot
	echo "Building $EDITION-$ARCH"
    umount -lf $EDITION-$ARCH/proc/ || true
    umount -lf $EDITION-$ARCH/sys/ || true
    umount -lf $EDITION-$ARCH/dev/ || true
	rm -r $EDITION-$ARCH/ || true
	debootstrap --arch=$ARCH --components=main,contrib,non-free --include=gnupg2,nano --exclude=parrot-core $EDITION $EDITION-$ARCH https://deb.parrot.sh/direct/parrot/
	echo "Customizing $EDITION-$ARCH"
    mount -t proc /proc $EDITION-$ARCH/proc/
    mount --rbind /sys $EDITION-$ARCH/sys/
    mount --rbind /dev $EDITION-$ARCH/dev/
    chroot $EDITION-$ARCH /bin/apt update
    echo -e "y\n" | chroot $EDITION-$ARCH /bin/apt -y install --no-install-recommends parrot-core base-files
    rm -rf $EDITION-$ARCH/var/lib/apt/lists/*
    rm -rf $EDITION-$ARCH/var/cache/apt/*
    umount -lf $EDITION-$ARCH/proc
    umount -lf $EDITION-$ARCH/sys
    umount -lf $EDITION-$ARCH/dev
	echo "Done $EDITION-$ARCH"
}


mkdir -p images
for arch in amd64 i386 arm64 armhf; do
    bootstrap $arch
    tar cvf - parrot-$arch | xz -q -c --best --extreme - > images/Parrot-rootfs-${VERSION}_$arch.tar.xz
done
