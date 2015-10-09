#!/bin/bash
git submodule init
git submodule update

mkdir tmp

galaxy_dir="lib/galaxy/"

# Prepare environment
./src/install_libraries.sh 

# Prepare galaxy
./src/prepare_galaxy.sh $galaxy_dir

rm -rf tmp

# Launch galaxy
cd $galaxy_dir
sh run.sh