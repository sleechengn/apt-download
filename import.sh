#!/usr/bin/bash
TARGET=$1
if [ "$TARGET" ]; then
for f in $TARGET/*.deb; do
	pack=$(dpkg -I $f|grep "Package:"|awk '{print $2}')
	pack_dir=$(echo $pack|sed 's/:/%3A/g')
	fn=$(echo $f|awk -F "/" '{print $2}')
	if [ -e "$(dirname $0)/debs/debian/13/$pack_dir" ]; then
		echo "已经存在包:$pack_dir"
		if [ -e "$(dirname $0)/debs/debian/13/$pack_dir/$fn" ]; then
			echo "已经存在:$fn"
			else
			cp -ra $f $(dirname $0)/debs/debian/13/$pack_dir
		fi
		else
		mkdir $(dirname $0)/debs/debian/13/$pack_dir
		cp -ra $f $(dirname $0)/debs/debian/13/$pack_dir
	fi
done
fi
