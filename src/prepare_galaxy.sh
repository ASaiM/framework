#!/bin/bash

galaxy_dir=$1
current_dir=$PWD

# Prepare galaxy tool sections
function create_tool_section_dir {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

create_tool_section_dir $galaxy_dir/tools/extract
create_tool_section_dir $galaxy_dir/tools/concatenate
create_tool_section_dir $galaxy_dir/tools/assemble_paired_end
create_tool_section_dir $galaxy_dir/tools/manipulate_rna
create_tool_section_dir $galaxy_dir/tools/usearch
create_tool_section_dir $galaxy_dir/tools/RDPTools
create_tool_section_dir $galaxy_dir/tools/cluster_sequences
create_tool_section_dir $galaxy_dir/tools/search_similarity
create_tool_section_dir $galaxy_dir/tools/assigne_taxonomy_to_non_rRNA
create_tool_section_dir $galaxy_dir/tools/assigne_taxonomy_to_rRNA
create_tool_section_dir $galaxy_dir/tools/analyze_metabolism

# Prepary galaxy tools which are in git submodules
./src/prepare_git_submodules.sh

#cp -r lib/galaxy_tools/* $galaxy_dir/tools/

# Prepare galaxy tools
./src/prepare_galaxy_tools.sh $galaxy_dir

# Prepare galaxy config
cp config/* $galaxy_dir/config/

# Prepare galaxy tool_data
cp data/tool-data/* $galaxy_dir/tool-data

if [ ! -d $galaxy_dir/dependency_dir ]; then
    mkdir $galaxy_dir/dependency_dir
fi

# Prepare ftp directory
if [ ! -d $galaxy_dir/database/ftp ]; then
    mkdir $galaxy_dir/database/ftp
fi

