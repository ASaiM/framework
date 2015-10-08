#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Assign taxonomy to rRNA..."
create_tool_section_dir $galaxy_tool_dir/assigne_taxonomy_to_rRNA