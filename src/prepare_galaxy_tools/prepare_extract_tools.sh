#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
current_dir=`pwd`

section_dir=extract

echo "Extract data..."
create_tool_section_dir $galaxy_tool_dir/$section_dir

echo " Extract sequence file..."
seq_file_extraction=$section_dir/extract_sequence_file
create_copy_tool_dir $tool_dir/$seq_file_extraction $galaxy_tool_dir/$seq_file_extraction

echo " Extract similarity search report..."
search_report_extraction=$section_dir/extract_similarity_search_report
create_copy_tool_dir $tool_dir/$search_report_extraction $galaxy_tool_dir/$search_report_extraction

