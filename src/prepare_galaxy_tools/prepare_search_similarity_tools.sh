#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=search_similarity

echo "Search similarity..."
create_tool_section_dir $galaxy_tool_dir/$section_dir

## blast
echo " NCBI Blast +..."
#ncbi_blast_plus_dir=$section_dir/ncbi_blast_plus
#create_copy_tool_dir $tool_dir/$section_dir/blast/tools/ncbi_blast_plus $galaxy_tool_dir/$ncbi_blast_plus

## diamond
echo " diamond..."
diamond=$section_dir/diamond
create_copy_tool_dir $tool_dir/bgruening_wrappers/tools/diamond $galaxy_tool_dir/$diamond

