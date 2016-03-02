#!/bin/bash

echo "Started time: " $(date +%r)

pid=$1
stat_file="stat_for_"$pid".txt"

if [[ -f $stat_file ]]; then
    rm $stat_file
fi

touch $stat_file
echo "Time %CPU Size" >> $stat_file
while true; do
    echo -n $(date +%r) >> $stat_file
    echo -n " " >> $stat_file
    echo -n `ps --format pcpu,size --no-headers $pid` >> $stat_file
    echo >> $stat_file
    sleep 1
done
