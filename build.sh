#!/bin/bash

set -e
set -o pipefail  # Bashism

export variant=$1
export arch=$2
export version=$3

lb clean
lb config
lb build

