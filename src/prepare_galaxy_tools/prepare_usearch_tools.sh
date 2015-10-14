#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=usearch

echo "Usearch..."
create_tool_section_dir $galaxy_tool_dir/$section_dir
cp $tool_dir/$section_dir/usearch8.1.1756* $galaxy_tool_dir/$section_dir

## derep_prefix
echo " derep_prefix..."
derep_prefix_dir=$section_dir/derep_prefix
create_copy_tool_dir $tool_dir/$derep_prefix_dir $galaxy_tool_dir/$derep_prefix

## derep_prefix
echo " uchime_denovo..."
derep_prefix_dir=$section_dir/uchime_denovo
create_copy_tool_dir $tool_dir/$derep_prefix_dir $galaxy_tool_dir/$uchime_denovo