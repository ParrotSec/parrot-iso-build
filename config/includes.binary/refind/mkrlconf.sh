#!/bin/bash

# Script to create a refind_linux.conf file for the current Linux
# installation.

# copyright (c) 2012 by Roderick W. Smith
#
# This program is licensed under the terms of the GNU GPL, version 3,
# a copy of which should be distributed with this program.

# Usage:
#
# ./mkrlconf.sh [--force]
#
# Options:
#
#   --force  -- Overwrite an existing file (default is to not replace existing file)

# Revision history:
#
#  0.7.7 -- Fixed bug that caused stray PARTUUID= and line breaks in generated file
#  0.5.1 -- Initial release
#
# Note: mkrlconf.sh version numbers match those of the rEFInd package
# with which they first appeared.

RLConfFile="/boot/refind_linux.conf"

if [[ ! -f $RLConfFile || $1 == "--force" ]] ; then
   if [[ -f /etc/default/grub ]] ; then
      # We want the default options used by the distribution, stored here....
      source /etc/default/grub
   fi
   RootFS=`df / | grep dev | cut -f 1 -d " "`
   StartOfDevname=`echo $RootFS | cut -b 1-7`
   if [[ $StartOfDevname == "/dev/sd" || $StartOfDevName == "/dev/hd" ]] ; then
      # Identify root filesystem by UUID rather than by device node, if possible
      Uuid=`blkid -o export -s UUID $RootFS 2> /dev/null | grep UUID=`
      if [[ -n $Uuid ]] ; then
         RootFS=$Uuid
      fi
   fi
   DefaultOptions="$GRUB_CMDLINE_LINUX $GRUB_CMDLINE_LINUX_DEFAULT"
   echo "\"Boot with standard options\"        \"ro root=$RootFS $DefaultOptions \"" > $RLConfFile
   echo "\"Boot to single-user mode\"          \"ro root=$RootFS $DefaultOptions single\"" >> $RLConfFile
   echo "\"Boot with minimal options\"         \"ro root=$RootFS\"" >> $RLConfFile
else
   echo "Existing $RLConfFile found! Not overwriting!"
   echo "To force overwriting, pass the --force option."
   echo ""
fi
