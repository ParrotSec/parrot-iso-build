#!/bin/bash
set -e

adduser --disabled-password --gecos "" parrot
echo "parrot:toor" | chpasswd
adduser parrot audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth sudo fuse dialout
