#!/bin/bash

galaxy_dir="../galaxy"
current_dir=$PWD

# Clone or pull galaxy code
if [ -d $galaxy_dir ]; then
    cd $galaxy_dir
    git pull 
    cd $current_dir
else
    git clone https://github.com/galaxyproject/galaxy.git $galaxy_dir
fi

# Prepare galaxy tools
./src/prepare_galaxy_tools.sh $galaxy_dir

# Prepare galaxy config
cp config/* $galaxy_dir/config/

# Launch galaxy
cd $galaxy_dir
sh run.sh