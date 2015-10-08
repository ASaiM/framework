#!/bin/bash

galaxy_dir="lib/galaxy/"
galaxy_tool_dir=$galaxy_dir/tools/

tool_dir=lib/galaxy_tools/
db_dir=data/db/

current_dir=$PWD

# Prepare databases
./src/prepare_databases.sh $db_dir

# Prepare galaxy tools
./src/prepare_galaxy_tools.sh $galaxy_tool_dir $tool_dir $db_dir

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

