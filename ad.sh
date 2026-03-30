#!/usr/bin/bash

echo "root pack:$1"
ROOT_PACK=$1
ROOT_DIR=$(realpath $(dirname $0))/debs
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
		apt download $CURRD
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
