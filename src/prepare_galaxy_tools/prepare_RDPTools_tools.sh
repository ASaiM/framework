#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "RDPTools..."
create_tool_section_dir $galaxy_tool_dir/RDPTools

## RDPTools
echo " RDPTools..."
rdptools_dir=RDPTools/
cd $tool_dir/$rdptools_dir/RDPTools
git submodule init
git submodule update
export PATH="/bin/ant/bin:$PATH"
if [ ! -f "FrameBot.jar" ]; then 
    make >> $current_dir/tmp/RDPTools_make
    if grep "Error" $current_dir/tmp/RDPTools_make > /dev/null ; then
        echo "Error with make for RDPTools"
        exit
    fi
else
    echo -e "  recompile? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        make clean
        make >> $current_dir/tmp/RDPTools_make
        if grep "Error" $current_dir/tmp/RDPTools_make > /dev/null ; then
            echo "Error with make for RDPTools"
            exit
        fi
    fi
fi
cd $current_dir
create_copy_tool_dir $tool_dir/$rdptools_dir $galaxy_tool_dir/$rdptools_dir