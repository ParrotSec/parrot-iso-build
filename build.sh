#!/bin/bash

set -e
set -o pipefail  # Bashism

variant=$1
arch=$2
version=$3

lb clean
lb config
lb build

