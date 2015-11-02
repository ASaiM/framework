#!/bin/bash

function create_symlink {
    if [ -e $1 ]; then
        if [ ! -L $1 ]; then
            rm -rf $1
            ln -s $2 $1
        fi
    else
        ln -s $2 $1
    fi 
}

galaxy_dir=$1
galaxy_tool_dir=$galaxy_dir/tools/

tool_dir=lib/galaxy_tools/
db_dir=data/db/

current_dir=$PWD

# Prepare databases
./src/prepare_databases.sh $db_dir

# Prepare galaxy tools
./src/prepare_galaxy_tools.sh $galaxy_tool_dir $tool_dir $db_dir

$tool_dir=$PWD/$tool_dir
$galaxy_tool_dir=$PWD/$galaxy_tool_dir
for i in $( ls ${tool_dir}/ )
do
    if [ $i == 'extract' ]; then
        create_symlink $galaxy_dir/tools/$i/extract_sequence_file \
            $tool_dir/$i/extract_sequence_file
        create_symlink $galaxy_dir/tools/$i/extract_similarity_search_report \
            $tool_dir/$i/extract_similarity_search_report
    else
        create_symlink $galaxy_dir/tools/$i $tool_dir/$i
    fi 
done

# Prepare galaxy config

for i in $( ls config/ )
do
    create_symlink $galaxy_dir/config/$i $PWD/config/$i
done

# Prepare galaxy tool_data
for i in $( ls data/tool-data/ )
do 
    create_symlink $galaxy_dir/tool-data/$i $PWD/data/tool-data/$i
done

if [ ! -d $galaxy_dir/dependency_dir ]; then
    mkdir $galaxy_dir/dependency_dir
fi

# Prepare ftp directory
if [ ! -d $galaxy_dir/database/ftp ]; then
    mkdir $galaxy_dir/database/ftp
fi

