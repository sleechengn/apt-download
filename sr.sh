#!/usr/bin/bash
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
echo "deb [trusted=yes] file:$(realpath $(pwd)) ./" > /etc/apt/sources.list.d/local-src.list
