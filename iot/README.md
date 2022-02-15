# Parrot ARM

Repository for ParrotOS on ARM platform.

Currently vmdb2 is used to build the *armhf* images for Raspberry Pi 3 Model B+ and 4 Model B devices.

Based on [Debian build configuration](https://salsa.debian.org/raspi-team/image-specs).

To start the build process, you must have a Debian system and install vmdb2 with `sudo apt install vmdb2` or run the `check_vmdb2.sh`. After that, just run the `build.sh` script.

This build was also possible thanks to the help of @danterolle, @palinuro, @kyb3rcipher, @serverket and in particular @mibofra. 
