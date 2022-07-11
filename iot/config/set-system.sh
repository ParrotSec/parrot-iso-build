#!/bin/bash

# source config
source /tmp/default.conf

# Set hostname
echo "$hostname" > /etc/hostname

cat > /etc/hosts <<EOM
127.0.0.1       localhost
127.0.1.1       $hostname
::1             localhostnet.ifnames=0 ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOM

# Set users
echo "root:$password" | chpasswd
adduser --gecos $user --disabled-password $user
echo "$user:$password" | chpasswd
usermod -aG sudo,users,audio,dip,video,plugdev,netdev,bluetooth,sambashare,docker $user

echo "Password for $user: $password" > ~/Desktop/password.txt
