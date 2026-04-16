#!/usr/bin/bash
OSS_T=$(cat /etc/os-release |grep "^ID="|tr -d \"|awk -F = '{print $2}')
VER_T=$(cat /etc/os-release |grep "^VERSION_ID="|tr -d \"|awk -F = '{print $2}')
ROOT_DIR=$(realpath $(pwd))/debs/$OSS_T/$VER_T
cd $ROOT_DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
echo "deb [trusted=yes] file:$(realpath $(pwd)) ./" > /etc/apt/sources.list.d/a-local-src.list
