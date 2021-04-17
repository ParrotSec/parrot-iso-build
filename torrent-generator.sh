#!/bin/bash
ISOFILE=$2
PATH=$1
echo "creating torrent for $ISOFILE"

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
https://ftp-stud.hs-esslingen.de/Mirrors/archive.parrotsec.org/$PATH/$ISOFILE,\
https://ftp.halifax.rwth-aachen.de/parrotsec/$PATH/$ISOFILE,\
https://ftp.nluug.nl/os/Linux/distr/parrot/$PATH/$ISOFILE,\
https://mirrors.dotsrc.org/parrot/$PATH/$ISOFILE,\
http://matojo.unizar.es/parrot/$PATH/$ISOFILE,\
https://ftp.cc.uoc.gr/mirrors/linux/parrot/$PATH/$ISOFILE,\
https://parrotsec.volia.net/$PATH/$ISOFILE,\
https://mirrors.up.pt/parrot/$PATH/$ISOFILE,\
https://mirror.yandex.ru/mirrors/$PATH/$ISOFILE,\
https://parrot.mirror.garr.it/mirrors/parrot/$PATH/$ISOFILE,\
http://mirrors.mit.edu/parrot/$PATH/$ISOFILE,\
http://sft.if.usp.br/parrot/$PATH/$ISOFILE,\
https://mirror.clarkson.edu/parrot/$PATH/$ISOFILE,\
https://mirror.kku.ac.th/parrot/$PATH/$ISOFILE,\
https://mirror.cedia.org.ec/parrot/$PATH/$ISOFILE,\
https://mirror.ueb.edu.ec/parrot/$PATH/$ISOFILE,\
https://mirror.0x.sg/parrot/$PATH/$ISOFILE,\
https://mirrors.tuna.tsinghua.edu.cn/parrot/$PATH/$ISOFILE,\
https://mirrors.ustc.edu.cn/parrot/$PATH/$ISOFILE,\
https://mirrors.shu.edu.cn/parrot/$PATH/$ISOFILE,\
http://free.nchc.org.tw/parrot/$PATH/$ISOFILE,\
https://mirrors.ocf.berkeley.edu/parrot/$PATH/$ISOFILE,\
http://mirror.lagoon.nc/pub/parrot/$PATH/$ISOFILE,\
https://mirror.parrotsec.org/parrot/$PATH/$ISOFILE,\
\
https://master.dl.sourceforge.net/project/parrotsecurity/$PATH/$ISOFILE,\
 -l 20 $ISOFILE
