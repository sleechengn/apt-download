#!/usr/bin/bash

echo "root pack:$1"
ROOT_PACK=$1
OSS_T=$(cat /etc/os-release |grep "^ID="|tr -d \"|awk -F = '{print $2}')
VER_T=$(cat /etc/os-release |grep "^VERSION_ID="|tr -d \"|awk -F = '{print $2}')
ROOT_DIR=$(realpath $(pwd))/debs/$OSS_T/$VER_T
mkdir -p $ROOT_DIR

function downloadversion {
	TMP_DIR=$1
	PACK_DIR=$ROOT_DIR/$3
	PACK=$2
	PACK_VER=$3
	find $PACK_DIR/*.deb |xargs -i dpkg -I {}
}

function download {
	CURRD=$1
	PACK_DIR=$ROOT_DIR/$CURRD
	TMP_DIR=$ROOT_DIR/tmp/$$/$CURRD
	rm -rf $TMP_DIR
	if [ ! -e $TMP_DIR ]; then
		mkdir -p $TMP_DIR
	fi
	if [ ! -e $PACK_DIR ]; then
		echo "will download $CURRD"
		cd $TMP_DIR
		apt-cache madison $CURRD|awk -F "|" '{print $2}'|tr -d ' '|uniq|xargs -i apt download $CURRD={}
		#apt download $CURRD
		dl_status=$?
		echo $dl_status
		if [ $dl_status -eq 0 ]; then
			cd $ROOT_DIR
			mv $TMP_DIR $ROOT_DIR &
		else
			echo "download failure $CURRD"
		fi
		cd $ROOT_DIR
	else
		echo "exist $CURRD update"
		

		apt-cache madison $CURRD|awk -F "|" '{print $2}'|tr -d ' '|uniq| while IFS= read -r line
		do
			if [ "$(find $PACK_DIR|grep -F .deb|xargs -i dpkg -I {}|grep Version|awk '{print $2}'|grep -x $line)" ]; then
				echo "存在 $line"
			else
			cd $TMP_DIR
				echo "download $line"
				apt download $CURRD=$line
				dl_status=$?
				echo $dl_status
					if [ $dl_status -eq 0 ]; then
					mv $TMP_DIR/*.deb $PACK_DIR &
					else
					echo "download failure $CURRD"
					rm -rf $TMP_DIR/*.deb
					fi
			fi
		done
		cd $ROOT_DIR
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
