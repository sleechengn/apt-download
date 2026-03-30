#!/usr/bin/bash

ROOT_PACK=$1
OSS_T=$(cat /etc/os-release |grep "^ID="|tr -d \"|awk -F = '{print $2}')
VER_T=$(cat /etc/os-release |grep "^VERSION_ID="|tr -d \"|awk -F = '{print $2}')
ROOT_DIR=$(realpath $(pwd))/debs/$OSS_T/$VER_T

if [ -e $ROOT_DIR/$ROOT_PACK/dependencies.txt ]; then
	echo $ROOT_DIR/debs/$ROOT_PACK/dependencies.txt
	for pack in $(cat $ROOT_DIR/debs/$ROOT_PACK/dependencies.txt); do
		if [ "$(dpkg -l|awk '{print $2}'|grep -x $pack)" ]; then
			echo "exist pack $pack"
		else
			echo "install $pack"
			dpkg -i $ROOT_DIR/debs/$pack/*.deb
		fi
	done
else
	echo "not found"
fi
