#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Cluster sequences..."
create_tool_section_dir $galaxy_tool_dir/cluster_sequences

## cd-hit
echo " cd-hit..."
cd_hit_dir=cluster_sequences/cd-hit/
cd $tool_dir/$cd_hit_dir/cd-hit
if [ ! -f "cd-hit" ]; then 
    make openmp=no >> $current_dir/tmp/cd-hit_make
    if grep "Error" $current_dir/tmp/cd-hit_make > /dev/null ; then
        echo "Error with make for cd-hit"
        exit
    fi
else
    echo -e "  recompile? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        make clean
        make openmp=no >> $current_dir/tmp/cd-hit_make
        if grep "Error" $current_dir/tmp/cd-hit_make > /dev/null ; then
            echo "Error with make for cd-hit"
            exit
        fi
    fi
fi
cd $current_dir
create_copy_tool_dir $tool_dir/$cd_hit_dir $galaxy_tool_dir/$cd_hit_dir