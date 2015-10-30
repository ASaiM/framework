#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=cluster_sequences

echo "Cluster sequences..."
create_tool_section_dir $galaxy_tool_dir/$section_dir

echo " Format cd-hit outputs..."
format_cd_hit_output_dir=$section_dir/format_cd_hit_output
create_copy_tool_dir $tool_dir/$format_cd_hit_output \
    $galaxy_tool_dir/$format_cd_hit_output

