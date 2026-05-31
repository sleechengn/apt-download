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
	if [ -e "$(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir" ]; then
		if [ -e "$(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir/$fn" ]; then
			echo "exist: $fn"
		else
			cp -ra $f $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
			echo "import: $f"
		fi
	else
		mkdir $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
		cp -ra $f $(dirname $0)/debs/$OSS_T/$VER_T/$pack_dir
		echo "import: $f"
	fi
done
fi
