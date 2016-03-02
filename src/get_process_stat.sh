#!/bin/bash

echo "Started time: " 
echo $(date +%r)

pid=$1
stat_file="stat_for_"$pid

if [[ -f $stat_file ]]; then
    rm $stat_file
fi

touch $stat_file
while true; do
    echo -n $(date +%r) >> $stat_file
    echo -n `ps --format pcpu,size --no-headers $pid` >> $stat_file
    echo >> $stat_file
    sleep 1
done