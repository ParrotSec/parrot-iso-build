#!/bin/bash
set -e

SOURCEDIR=$(dirname $0)
ROOTDIR="$1"

# Do not start services during installation.
echo "I: disabling services during setup"
echo exit 101 > $ROOTDIR/usr/sbin/policy-rc.d
chmod +x $ROOTDIR/usr/sbin/policy-rc.d

# enable for apt-cacher-ng
echo "I: enabling apt cacher"
echo "Acquire::http { Proxy \"http://localhost:3142\"; };" > $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng

#configure temporary networking
echo "I: configuring temporary networking"
rm $ROOTDIR/etc/resolv.conf
echo -e "# ParrotDNS/OpenNIC
nameserver 1.1.1.1
nameserver 139.99.96.146
nameserver 37.59.40.15
nameserver 185.121.177.177

# Round Robin
options rotate" > $ROOTDIR/etc/resolv.conf

# Configure apt.
echo "I: configuring apt"
export DEBIAN_FRONTEND=noninteractive
cat $SOURCEDIR/parrotsec.gpg | chroot $ROOTDIR apt-key add -
echo > $ROOTDIR/etc/apt/sources.list
mkdir -p $ROOTDIR/etc/apt/sources.list.d/
mkdir -p $ROOTDIR/etc/apt/apt.conf.d/
echo "deb http://deb.parrotsec.org/parrot stable main contrib non-free" > $ROOTDIR/etc/apt/sources.list.d/parrot.list
chroot $ROOTDIR apt update
chroot $ROOTDIR apt -y install parrot-core

echo "I: copying custom apt configs"
cp $SOURCEDIR/etc/apt/sources.list $ROOTDIR/etc/apt/sources.list
cp $SOURCEDIR/etc/apt/apt.conf.d/50raspi $ROOTDIR/etc/apt/apt.conf.d/50raspi
chroot $ROOTDIR apt update

# Regenerate SSH host keys on first boot.
echo "I: regenerating ssh keys"
chroot $ROOTDIR apt-get install -y openssh-server rng-tools
rm -f $ROOTDIR/etc/ssh/ssh_host_*
mkdir -p $ROOTDIR/etc/systemd/system
cp $SOURCEDIR/etc/systemd/system/regen-ssh-keys.service $ROOTDIR/etc/systemd/system/regen-ssh-keys.service
chroot $ROOTDIR systemctl enable regen-ssh-keys ssh

# Configure.
echo "I: configuring boot and network setups"
cp $SOURCEDIR/boot/cmdline.txt $ROOTDIR/boot/cmdline.txt
cp $SOURCEDIR/boot/config.txt $ROOTDIR/boot/config.txt
cp -r $SOURCEDIR/etc/default $ROOTDIR/etc/default
cp $SOURCEDIR/etc/fstab $ROOTDIR/etc/fstab
cp $SOURCEDIR/etc/modules $ROOTDIR/etc/modules
cp $SOURCEDIR/etc/network/interfaces $ROOTDIR/etc/network/interfaces

FILE="$SOURCEDIR/config/authorized_keys"
if [ -f $FILE ]; then
    echo "I: Adding authorized_keys."
    mkdir -p $ROOTDIR/root/.ssh/
    cp $FILE $ROOTDIR/root/.ssh/
else
    echo "I: No authorized_keys, allowing root login with password on SSH."
    sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/" $ROOTDIR/etc/ssh/sshd_config
fi

# Install kernel.
echo "I: installing kernel"
mkdir -p $ROOTDIR/lib/modules
chroot $ROOTDIR apt install -y ca-certificates curl binutils git-core kmod
wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update -O $ROOTDIR/usr/local/sbin/rpi-update
chmod a+x $ROOTDIR/usr/local/sbin/rpi-update
SKIP_WARNING=1 SKIP_BACKUP=1 ROOT_PATH=$ROOTDIR BOOT_PATH=$ROOTDIR/boot $ROOTDIR/usr/local/sbin/rpi-update

# Install extra packages.
echo "I: installing extra packages"
chroot $ROOTDIR apt install -y apt-utils nano whiptail netbase less iputils-ping net-tools isc-dhcp-client parrot-core anacron fake-hwclock ntp fail2ban needrestart sudo
chroot $ROOTDIR apt install -y parrot-interface parrot-mate parrot-pico geany bleachbit

# Clean some shit.
echo "I: cleaning unwanted packages"
chroot $ROOTDIR apt -y purge firejail samba

#create user
#chroot $ROOTDIR bash useradd -m -p $(mkpasswd -m sha-512 parrot) -s /bin/bash parrot

echo "I: creating parrot user"
cp $SOURCEDIR/hooks/create-user.sh $ROOTDIR/create-user.sh
chroot $ROOTDIR /create-user.sh



#configure networking
echo "I: configuring networking"
chroot $ROOTDIR apt-get update
chroot $ROOTDIR apt-get -y install resolvconf
chroot $ROOTDIR systemctl enable resolvconf
chroot $ROOTDIR systemctl start resolvconf
chroot $ROOTDIR rm /etc/resolv.conf
echo -e "
# ParrotDNS/OpenNIC
nameserver 139.99.96.146
nameserver 37.59.40.15
nameserver 185.121.177.177

# Round Robin
options rotate" > $ROOTDIR/etc/resolvconf/resolv.conf.d/tail
ln -s /etc/resolvconf/run/resolv.conf $ROOTDIR/etc/resolv.conf

# Create a swapfile.
echo "I: creating swapfile"
dd if=/dev/zero of=$ROOTDIR/var/swapfile bs=1M count=128
chroot $ROOTDIR mkswap /var/swapfile
echo /var/swapfile none swap sw 0 0 >> $ROOTDIR/etc/fstab

# Done.
echo "I: ultimating build"
rm $ROOTDIR/usr/sbin/policy-rc.d
echo "cleaning the system with bleachbit"
chroot $ROOTDIR bleachbit -c system.localizations apt.autoclean apt.autoremove apt.package_lists deepscan.backup deepscan.ds_store deepscan.thumbs_db deepscan.tmp system.cache system.rotated_logs thumbnails.cache &> /dev/null && echo "done"
rm $ROOTDIR/etc/apt/apt.conf.d/50apt-cacher-ng

