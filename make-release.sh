#!/bin/bash

# Makes a release zip of the tool.
#
# First do 
#
# git tag -a -m x.y.z x.y.z
#
# Then this.

source ./common-build.sh

rm $binary $zipfile >& /dev/null

build_release
cp $built_release_binary ./$binary
zip $zipfile $binary
rm $binary
