#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <ISO_PATH> <ISO_FILENAME>"
    echo "Creates a torrent for the specified ISO file."
}

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

ISOFILE=$2
ISO_PATH=$1

# Check if the ISO file exists
if [ ! -f "$ISO_PATH/$ISOFILE" ]; then
    echo "Error: ISO file '$ISO_PATH/$ISOFILE' not found."
    exit 1
fi

# Function to print verbose messages
verbose() {
    if [ "$VERBOSE" = "true" ]; then
        echo "$@"
    fi
}

# Parse command-line options
while getopts ":v" opt; do
    case $opt in
        v)
            VERBOSE=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

echo "Creating torrent for $ISOFILE"

/usr/bin/mktorrent \
-a https://tracker.parrot.sh/announce,https://wolf.parrotsec.io/announce \
-a https://ashrise.com:443/phoenix/announce \
-a http://tracker.bt4g.com:2095/announce \
-a http://ipv4announce.sktorrent.eu:6969/announce \
-a udp://bt1.archive.org:6969/announce \
-a udp://tracker.opentrackr.org:1337/announce \
-a udp://open.demonii.com:1337/announce \
-a udp://tracker.ccc.de:80/announce \
-a udp://tracker.openbittorrent.com:80/announce \
-a udp://tracker.publicbt.com:80/announce \
-a udp://ipv4.tracker.harry.lu:80/announce,udp://ipv6.tracker.harry.lu:80/announce \
-a udp://tracker.coppersurfer.tk:6969/announce \
-a udp://tracker.moeking.me:6969/announce \
-c "Parrot Security OS official torrent - don't seed it if an updated version is available. for security reasons we don't want old releases to be seeded." \
-w \
https://ftp-stud.hs-esslingen.de/Mirrors/archive.parrotsec.org/$ISO_PATH/$ISOFILE,\
https://ftp.halifax.rwth-aachen.de/parrotsec/$ISO_PATH/$ISOFILE,\
https://ftp.nluug.nl/os/Linux/distr/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.dotsrc.org/parrot/$ISO_PATH/$ISOFILE,\
http://matojo.unizar.es/parrot/$ISO_PATH/$ISOFILE,\
https://ftp.cc.uoc.gr/mirrors/linux/parrot/$ISO_PATH/$ISOFILE,\
https://parrotsec.volia.net/$ISO_PATH/$ISOFILE,\
https://mirrors.up.pt/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.yandex.ru/mirrors/$ISO_PATH/$ISOFILE,\
https://parrot.mirror.garr.it/mirrors/parrot/$ISO_PATH/$ISOFILE,\
http://mirrors.mit.edu/parrot/$ISO_PATH/$ISOFILE,\
http://sft.if.usp.br/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.clarkson.edu/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.kku.ac.th/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.cedia.org.ec/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.ueb.edu.ec/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.0x.sg/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.tuna.tsinghua.edu.cn/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.ustc.edu.cn/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.shu.edu.cn/parrot/$ISO_PATH/$ISOFILE,\
http://free.nchc.org.tw/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.ocf.berkeley.edu/parrot/$ISO_PATH/$ISOFILE,\
http://mirror.lagoon.nc/pub/parrot/$ISO_PATH/$ISOFILE,\
https://mirror.parrot.sh/parrot/$ISO_PATH/$ISOFILE,\
https://mirrors.aliyun.com/parrot/ \
https://master.dl.sourceforge.net/project/parrotsecurity/$ISO_PATH/$ISOFILE \
-l 20 $ISOFILE
