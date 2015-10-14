#!/bin/bash
galaxy_dir="lib/galaxy/"

reset=false
for i 
do 
    if [ $i = '-reset' ]; then
        reset=true
    fi
done

if [ -d $galaxy_dir ]; then
    if $reset; then
        echo "Reset Galaxy"
        sudo rm -rf $galaxy_dir
    fi
fi


mkdir tmp

git submodule init
if $reset; then
    git submodule foreach git reset --hard HEAD
fi
git submodule update
if $reset; then
    git submodule foreach "git checkout master; git pull"
    git submodule foreach git clean -f
fi


# Prepare environment
./src/install_libraries.sh 

# Prepare galaxy
./src/prepare_galaxy.sh $galaxy_dir

rm -rf tmp

# Launch galaxy
cd $galaxy_dir
sh run.sh >> run_galaxy

