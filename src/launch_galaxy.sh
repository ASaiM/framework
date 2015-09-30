#!/bin/bash

mkdir tmp

galaxy_dir="lib/galaxy/"

# Prepare environment
./src/install_libraries.sh $galaxy_dir #> tmp/install_libraries
#if grep "Error" tmp/install_libraries > /dev/null ; then
#    echo "Error with install_libraries.sh"
#    exit
#fi

# Prepare galaxy
./src/prepare_galaxy.sh $galaxy_dir #> tmp/prepare_galaxy
#if grep "Error" tmp/prepare_galaxy > /dev/null ; then
#    echo "Error with prepare_galaxy.sh"
#    exit
#fi

rm -rf tmp

# Launch galaxy
cd $galaxy_dir
sh run.sh