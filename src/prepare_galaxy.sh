#!/bin/bash

galaxy_dir="galaxy/"
current_dir=$PWD

# Clone or pull galaxy code
if [ -d $galaxy_dir ]; then
    cd $galaxy_dir
    git pull 
    cd $current_dir
else
    git clone https://github.com/galaxyproject/galaxy.git $galaxy_dir
fi

cp -r tools/* $galaxy_dir/tools/

# Prepare galaxy tools
./src/prepare_galaxy_tools.sh $galaxy_dir

# Prepare galaxy config
cp config/* $galaxy_dir/config/

if [ ! -d $galaxy_dir/dependency_dir ]; then
    mkdir $galaxy_dir/dependency_dir
fi

# Prepare ftp directory
if [ ! -d $galaxy_dir/database/ftp ]; then
    mkdir $galaxy_dir/database/ftp
fi

# Launch galaxy
cd $galaxy_dir
sh run.sh