#!/bin/bash

sudo debootstrap --arch=amd64 rolling rolling-amd64 > rolling-amd64.log
sudo debootstrap --arch=i386 rolling rolling-i386 > rolling-i386.log
sudo debootstrap --arch=amd64 lts lts-amd64 > lts-amd64.log
sudo debootstrap --arch=i386 lts lts-i386 > lts-i386.log
sudo debootstrap --arch=arm64 lts lts-arm64 > lts-arm64.log
sudo debootstrap --arch=armhf lts lts-armhf > lts-armhf.log

sudo tar -C rolling-amd64 -c . | docker import - parrotsec/core:rolling-amd64
sudo tar -C rolling-i386 -c . | docker import - parrotsec/core:rolling-i386
sudo tar -C lts-amd64 -c . | docker import - parrotsec/core:lts-amd64
sudo tar -C lts-i386 -c . | docker import - parrotsec/core:lts-i386
sudo tar -C lts-arm64 -c . | docker import - parrotsec/core:lts-arm64
sudo tar -C lts-armhf -c . | docker import - parrotsec/core:lts-armhf
sudo tar -C lts-amd64 -c . | docker import - parrotsec/core:latest
