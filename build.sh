#!/bin/bash

set -e
set -o pipefail  # Bashism

export variant=$2
export arch=$3
export version=$4


function helper() {
	echo -e "Parrot Build System


USAGE
 	 ./build.sh <action> [<variant> <arch> <version>]

EXPLAINATION

      action  - help, build
                the action to be performed by this program
                help will show this message, build will start
                the build if correctly combined with variant, arch and version

      variant - home, security, kde, studio

                the edition of parrot that is going to
                be taken from the templates folder

      arch    - i386, amd64, armhf, arm64
                the architecture that will be built

      version - the version of parrot that has to be
                written in the live boot menu

EXAMPLE
 	 ./build.sh build home amd64 4.6-CUSTOM
"
}

function build() {
	lb clean
	rm -rf config || true
	lb config
	lb build
	mv live-image-*.hybrid.iso ../Parrot-$variant-$version\_$arch.iso
}

case $1 in
	build)
		build
	;;
	help)
		helper
	;;
	*)
		helper
	;;
esac
