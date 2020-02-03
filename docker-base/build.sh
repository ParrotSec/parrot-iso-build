#!/bin/bash

sudo debootstrap --arch=amd64 --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor rolling rolling-amd64 https://mirror.parrot.sh/mirrors/parrot > rolling-amd64.log
sudo debootstrap --arch=i386 --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor rolling rolling-i386 https://mirror.parrot.sh/mirrors/parrot > rolling-i386.log
sudo debootstrap --arch=amd64 --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor lts lts-amd64 https://mirror.parrot.sh/mirrors/parrot > lts-amd64.log
sudo debootstrap --arch=i386 --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor lts lts-i386 https://mirror.parrot.sh/mirrors/parrot > lts-i386.log
sudo debootstrap --arch=arm64 --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor lts lts-arm64 https://mirror.parrot.sh/mirrors/parrot > lts-arm64.log
sudo debootstrap --arch=armhf --components=main,contrib,non-free --include=parrot-core,apt-parrot --exclude=resolvconf,snapd,firejail,apparmor lts lts-armhf https://mirror.parrot.sh/mirrors/parrot > lts-armhf.log

sudo tar -C rolling-amd64 -c . | docker import - parrotsec/core:rolling-amd64
sudo tar -C rolling-i386 -c . | docker import - parrotsec/core:rolling-i386
sudo tar -C lts-amd64 -c . | docker import - parrotsec/core:lts-amd64
sudo tar -C lts-i386 -c . | docker import - parrotsec/core:lts-i386
sudo tar -C lts-arm64 -c . | docker import - parrotsec/core:lts-arm64
sudo tar -C lts-armhf -c . | docker import - parrotsec/core:lts-armhf
sudo tar -C lts-amd64 -c . | docker import - parrotsec/core:latest

docker push parrotsec/core:rolling-amd64
docker push parrotsec/core:rolling-i386
docker push parrotsec/core:lts-amd64
docker push parrotsec/core:lts-i386
docker push parrotsec/core:lts-arm64
docker push parrotsec/core:lts-armhf
