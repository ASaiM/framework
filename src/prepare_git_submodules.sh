#!/bin/bash

tool_dir=lib/galaxy_tools/
current_dir=`pwd`

## sortmerna
echo "SortMeRNA..."
cd $tool_dir/rna_manipulation/sortmerna/sortmerna
./build.sh >> $current_dir/tmp/sortmerna_build
if grep "Error" $current_dir/tmp/sortmerna_build > /dev/null ; then
    echo "Error with build for sortmerna"
    exit
fi
cd $current_dir

## GenomeTools
if ! which gt > /dev/null; then 
    echo "GenomeTools..."
    echo -e "install GenomeTools on machine (needed to use reago)? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd $tool_dir/genometools/genometools/
        make >> $current_dir/tmp/genometools_make
        if grep "Error" $current_dir/tmp/genometools_make > /dev/null ; then
            echo "Error with make for GenomeTools"
            exit
        fi

        sudo make install >> $current_dir/tmp/genometools_make_install
        if grep "Error" $current_dir/tmp/genometools_make_install > /dev/null ; then
            echo "Error with make install for GenomeTools"
            exit
        fi
        cd $current_dir
    fi
fi

## reago
echo "Reago..."
cd $tool_dir/rna_manipulation/reago/reago
cd $current_dir

## RDPTools
echo "RDPTools..."
cd $tool_dir/RDPTools/RDPTools
git submodule init
git submodule update
export PATH="/bin/ant/bin:$PATH"
if [ ! -f "FrameBot.jar" ]; then 
    make >> $current_dir/tmp/RDPTools_make
    if grep "Error" $current_dir/tmp/RDPTools_make > /dev/null ; then
        echo "Error with make for RDPTools"
        exit
    fi
else
    echo -e "  recompile? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        make clean
        make >> $current_dir/tmp/RDPTools_make
        if grep "Error" $current_dir/tmp/RDPTools_make > /dev/null ; then
            echo "Error with make for RDPTools"
            exit
        fi
    fi
fi
cd $current_dir