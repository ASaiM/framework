#!/bin/bash
git submodule init
git submodule update

mkdir tmp


# Prepare environment
./src/install_libraries.sh 

# Prepare galaxy
./src/prepare_galaxy.sh 

rm -rf tmp

# Launch galaxy
cd $galaxy_dir
sh run.sh