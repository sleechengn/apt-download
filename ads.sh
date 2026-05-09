#!/usr/bin/bash
while [ $# -gt 0 ]; do 
    $(dirname $0)/ad.sh $1
    shift
done