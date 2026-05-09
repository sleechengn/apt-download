#!/usr/bin/bash
while [ $# -gt 0 ]; do
    $(dirname $0)/rs.sh $1
    shift
done