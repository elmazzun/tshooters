#!/bin/bash

set -ex

DISTROS=(
    debian-12
    ubuntu-22-04
)

for DISTRO in "${DISTROS[@]}"; do
    echo "$DISTRO"
    docker build -f Dockerfile.$DISTRO -t tshooters-build-env:$DISTRO .
    docker build --build-arg BASE_IMAGE=tshooters-build-env:$DISTRO -f Dockerfile.compile -t tshooters:$DISTRO .
done
