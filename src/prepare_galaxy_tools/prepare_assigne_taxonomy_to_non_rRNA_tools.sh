#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Assign taxonomy to non rRNA..."
create_tool_section_dir $galaxy_tool_dir/assigne_taxonomy_to_non_rRNA

## metaphlan 2
echo " Metaphlan 2..."
metaphlan2_dir=assigne_taxonomy_to_non_rRNA/metaphlan2
create_copy_tool_dir $tool_dir/$metaphlan2_dir $galaxy_tool_dir/$metaphlan2_dir
cd $galaxy_tool_dir/$metaphlan2_dir
if [ ! -d "metaphlan2/" ]; then
    echo "  cloning"
    #hg clone https://bitbucket.org/biobakery/metaphlan2 
else
    echo "  updating"
    cd "metaphlan2/"
    #hg pull
    cd ../
fi
cd $current_dir