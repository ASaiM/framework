#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=assigne_taxonomy_to_rRNA

echo "Assign taxonomy to rRNA..."
create_tool_section_dir $galaxy_tool_dir/$section_dir