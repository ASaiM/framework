#!/bin/bash
. src/misc.sh

sh $toolshed_dir/run_tool_shed.sh --stop-daemon

echo "Do you want to remove $toolshed_dir? (Y/n)"
read answer
if (( $answer == "y" )) || (( $answer == "Y" )); then
    echo "  Remove $toolshed_dir"
    rm -rf $toolshed_dir
fi