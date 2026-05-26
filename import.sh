#!/usr/bin/bash
set -e
TARGET=$1
OSS_T=$(cat /etc/os-release |grep "^ID="|tr -d \"|awk -F = '{print $2}')
VER_T=$(cat /etc/os-release |grep "^VERSION_ID="|tr -d \"|awk -F = '{print $2}')

if [ "$TARGET" ]; then
for f in $TARGET/*.deb; do
	pack=$(dpkg -I $f|grep "Package:"|awk '{print $2}')
	pack_dir=$(echo $pack|sed 's/:/%3A/g')
	fn=$(echo $f|awk -F "/" '{print $NF}')
	echo "处理文件：$fn"
	if [ -e "$(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir" ]; then
		echo "已经存在包:$pack_dir"
		if [ -e "$(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir/$fn" ]; then
			echo "已经存在:$fn"
			else
			cp -ra $f $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
		fi
	else
		mkdir $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
		cp -ra $f $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
	fi
done
fi
