#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Manipulate RNA..."
create_tool_section_dir $galaxy_tool_dir/manipulate_rna

## sortmerna
echo " SortMeRNA..."
sortmerna_dir=manipulate_rna/sortmerna
cd $tool_dir/$sortmerna_dir/sortmerna
./build.sh >> $current_dir/tmp/sortmerna_build
if grep "Error" $current_dir/tmp/sortmerna_build > /dev/null ; then
    echo "Error with build for sortmerna"
    exit
fi
cd $current_dir
create_copy_tool_dir $tool_dir/$sortmerna_dir $galaxy_tool_dir/$sortmerna_dir

## infernal
echo " infernal..."
infernal_dir=manipulate_rRNA/infernal
create_copy_tool_dir $tool_dir/$infernal_dir $galaxy_tool_dir/$infernal_dir
if ! which cmsearch > /dev/null; then
    echo "Infernal..."
    echo -e "install infernal on machine (needed to use reago)? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd $galaxy_tool_dir/$infernal_dir
        tar xzf infernal-1.1.1.tar.gz
        cd infernal-1.1.1

        ./configure >> $current_dir/tmp/infernal_configure
        if grep "Error" $current_dir/tmp/infernal_configure > /dev/null ; then
            echo "Error with configure for Infernal"
            exit
        fi

        make >> $current_dir/tmp/infernal_make
        if grep "Error" $current_dir/tmp/infernal_make > /dev/null ; then
            echo "Error with make for Infernal"
            exit
        fi 

        sudo make install >> $current_dir/tmp/infernal_make_install
        if grep "Error" $current_dir/tmp/infernal_make_install > /dev/null ; then
            echo "Error with make install for Infernal"
            exit
        fi
        cd $current_dir
    fi
fi

## reago
echo " Reago..."
reago_dir=manipulate_rna/reago/
create_copy_tool_dir $tool_dir/$reago_dir $galaxy_tool_dir/$reago_dir