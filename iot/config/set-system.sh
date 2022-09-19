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

# Set reduced-resources flag and recompile dconf database
#echo -e "\n[org/mate/marco/general]\nreduced-resources=true" >> /etc/dconf/db/local.d/parrot-skel

#dconf compile /etc/dconf/db/local /etc/dconf/db/local.d/
#dconf compile /etc/skel/.config/dconf/user /etc/dconf/db/local.d/

# Set users
echo "root:$password" | chpasswd
adduser --gecos $user --disabled-password $user
echo "$user:$password" | chpasswd
for group in sudo users audio video netdev dip plugdev lpadmin scanner bluetooth; do
    usermod -aG $group $user || true
done
