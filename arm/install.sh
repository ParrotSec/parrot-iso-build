#!/bin/sh
set -e

ROOTDIR="$1"
# Do not start services during installation.
echo exit 101 > $ROOTDIR/usr/sbin/policy-rc.d
chmod +x $ROOTDIR/usr/sbin/policy-rc.d

# Configure apt.
export DEBIAN_FRONTEND=noninteractive
cat raspbian.org.gpg | chroot $ROOTDIR apt-key add -
cat parrot-keyring.gpg | chroot $ROOTDIR apt-key add -
mkdir -p $ROOTDIR/etc/apt/sources.list.d/
mkdir -p etc/apt/sources.list.d/
mkdir -p $ROOTDIR/etc/apt/apt.conf.d/
echo "Acquire::http { Proxy \"http://[::1]:3142\"; };" > $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng
cp etc/apt/sources.list $ROOTDIR/etc/apt/sources.list
cp etc/apt/apt.conf.d/50raspi $ROOTDIR/etc/apt/apt.conf.d/50raspi
echo "deb http://[::1]:3142/archive.parrotsec.org/parrot testing main contrib non-free" > etc/apt/sources.list.d/parrot-testing.list
cp etc/apt/sources.list.d/parrot-testing.list $ROOTDIR/etc/apt/sources.list.d/parrot-testing.list
chroot $ROOTDIR apt-get update
chroot $ROOTDIR apt-get install -y --allow-unauthenticated parrot-archive-keyring

# Regenerate SSH host keys on first boot.
chroot $ROOTDIR rm /etc/motd /etc/resolvconf/resolv.conf.d/tail || true
chroot $ROOTDIR apt-get install -y openssh-server parrot-core apt-parrot desktop-base ntp
chroot $ROOTDIR apt-get -y --allow-downgrades dist-upgrade || true
cp etc/rc.local $ROOTDIR/etc/rc.local
chmod a+x $ROOTDIR/etc/rc.local
rm -f $ROOTDIR/etc/ssh/ssh_host_*
chroot $ROOTDIR update-rc.d rc.local defaults

# Configure.
cp boot/cmdline.txt $ROOTDIR/boot/cmdline.txt
cp boot/config.txt $ROOTDIR/boot/config.txt
cp etc/fstab $ROOTDIR/etc/fstab
cp etc/modules $ROOTDIR/etc/modules
cp etc/ssh/sshd_config $ROOTDIR/etc/ssh/sshd_config
cp etc/network/interfaces $ROOTDIR/etc/network/interfaces

# Install kernel.
mkdir -p $ROOTDIR/lib/modules
chroot $ROOTDIR apt-get install --allow-downgrades -y ca-certificates curl binutils git-core kmod
wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update -O $ROOTDIR/usr/local/sbin/rpi-update
chmod a+x $ROOTDIR/usr/local/sbin/rpi-update
SKIP_WARNING=1 SKIP_BACKUP=1 ROOT_PATH=$ROOTDIR BOOT_PATH=$ROOTDIR/boot $ROOTDIR/usr/local/sbin/rpi-update

# Install extra packages.
chroot $ROOTDIR apt-get install -y apt-utils vim nano whiptail netbase less iputils-ping net-tools isc-dhcp-client man-db parrot-tools parrot-interface parrot-mate
chroot $ROOTDIR apt-get install -y anacron fake-hwclock

# Install other recommended packages.
#apt-get install ntp apt-cron fail2ban needrestart

# Create a swapfile.
#dd if=/dev/zero of=$ROOTDIR/var/swapfile bs=1M count=512
#chroot $ROOTDIR mkswap /var/swapfile
#echo /var/swapfile none swap sw 0 0 >> $ROOTDIR/etc/fstab

# Done.
rm $ROOTDIR/usr/sbin/policy-rc.d
rm $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng
echo "deb http://archive.parrotsec.org/parrot testing main contrib non-free" > $ROOTDIR/etc/apt/sources.list.d/parrot-testing.list
