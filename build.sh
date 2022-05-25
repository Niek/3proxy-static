#!/bin/sh

# Usage: docker run --rm -it -v $(pwd):/app alpine:latest /app/build.sh

set -e # Exit on error

# 3proxy release version
VERSION=0.9.4

# change directory to the script location
cd "$(dirname "$0")"

# directory for build
mkdir -p build

# install dependencies
apk add --no-cache --virtual .build-deps build-base curl linux-headers 

# download and extract 3proxy
curl "https://github.com/3proxy/3proxy/archive/refs/tags/${VERSION}.tar.gz" -sLo 3proxy.tar.gz
tar xvfz 3proxy.tar.gz
cd 3proxy-${VERSION}

# apply the patch
patch -p0 < ../static-build.patch

# build 3proxy
make -f Makefile.Linux
strip bin/*
cp bin/* ../build/

# clean up
cd ../
rm -rf 3proxy.tar.gz 3proxy-${VERSION} .build-deps