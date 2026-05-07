#!/usr/bin/bash
while [ $# -gt 0 ]; do
    ./rs.sh $1
    shift
done