#!/bin/bash

galaxy_dir=$1
current_dir=$PWD

# Pull galaxy code
cd $galaxy_dir
git pull 
cd $current_dir

# Prepary galaxy tools which are in git submodules
./src/prepare_git_submodules.sh

cp -r lib/galaxy_tools/* $galaxy_dir/tools/

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

