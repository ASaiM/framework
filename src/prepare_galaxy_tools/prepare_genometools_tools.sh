#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=genometools

echo "GenomeTools..."
create_tool_section_dir $galaxy_tool_dir/$section_dir

## GenomeTools
echo " GenomeTools..."
genometools_dir=$section_dir/genometools/
if ! which gt > /dev/null; then 
    echo "GenomeTools..."
    echo -e "install GenomeTools on machine (needed to use reago)? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd $tool_dir/$genometools_dir
        make >> $current_dir/tmp/genometools_make
        if grep "Error" $current_dir/tmp/genometools_make > /dev/null ; then
            echo "Error with make for GenomeTools"
            exit
        fi

        sudo make install >> $current_dir/tmp/genometools_make_install
        if grep "Error" $current_dir/tmp/genometools_make_install > /dev/null ; then
            echo "Error with make install for GenomeTools"
            exit
        fi
        cd $current_dir
    fi
fi
create_copy_tool_dir $tool_dir/$genometools_dir $galaxy_tool_dir/$genometools_dir