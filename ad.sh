#!/usr/bin/bash

echo "root pack:$1"
ROOT_PACK=$1
OSS_T=$(cat /etc/os-release |grep "^ID="|tr -d \"|awk -F = '{print $2}')
VER_T=$(cat /etc/os-release |grep "^VERSION_ID="|tr -d \"|awk -F = '{print $2}')
ROOT_DIR=$(realpath $(pwd))/debs/$OSS_T/$VER_T
mkdir -p $ROOT_DIR

function download {
	CURRD=$1
	PACK_DIR=$ROOT_DIR/$CURRD
	TMP_DIR=$ROOT_DIR/tmp/$$/$CURRD
	rm -rf $TMP_DIR
	if [ ! -e $PACK_DIR ]; then
		echo "will download $CURRD"
		if [ ! -e $TMP_DIR ]; then
			mkdir -p $TMP_DIR
		fi
		cd $TMP_DIR
		apt-cache madison $CURRD|awk -F "|" '{print $2}'|tr -d ' '|uniq|xargs -i apt download $CURRD={}
		#apt download $CURRD
		dl_status=$?
		echo $dl_status
		if [ $dl_status -eq 0 ]; then
			cd $ROOT_DIR
			mv $TMP_DIR $ROOT_DIR
		else
			echo "download failure $CURRD"
		fi
		cd $ROOT_DIR
	else
		echo "exist $CURRD"
	fi
}

ALL_PACKS=$(apt-rdepends $ROOT_PACK|grep -v "^ ")
for pack in $ALL_PACKS; do
	cd $ROOT_DIR
	download $pack
	cd $ROOT_DIR
done

if [ ! -e $ROOT_DIR/$ROOT_PACK/dependencies.txt ]; then
	for pack in $ALL_PACKS; do
		echo $pack >> $ROOT_DIR/$ROOT_PACK/dependencies.txt
	done
fi
