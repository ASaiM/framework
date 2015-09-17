#!/bin/bash

galaxy_dir="lib/galaxy/"

# Prepare environment
sudo ./scripts/install_libraries.sh $galaxy_dir

# Prepare galaxy
./scripts/prepare_galaxy.sh $galaxy_dir

# Launch galaxy
cd $galaxy_dir
sh run.sh