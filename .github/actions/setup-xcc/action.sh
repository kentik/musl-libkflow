#!/usr/bin/env bash

set -eu -x

RELEASE=https://github.com/kentik/musl-xcc/releases/download/$VERSION/
ARCHIVE=xcc-$TARGET.tar.gz

curl -sL $RELEASE/$ARCHIVE | tar -xzf - -C /

echo "CC=/opt/xcc/bin/$TARGET-gcc"         >> $GITHUB_ENV
echo "CXX=/opt/xcc/bin/$TARGET-g++"        >> $GITHUB_ENV
echo "AR=/opt/xcc/bin/$TARGET-ar"          >> $GITHUB_ENV
echo "LD=/opt/xcc/bin/$TARGET-ld"          >> $GITHUB_ENV
echo "RANLIB=/opt/xcc/bin/$TARGET-ranlib"  >> $GITHUB_ENV
