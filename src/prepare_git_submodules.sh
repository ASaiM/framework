#!/bin/bash

tool_dir=lib/galaxy_tools/
current_dir=`pwd`
galaxy_tool_dir=lib/galaxy/tools/

function create_copy_tool_dir {
    if [ ! -d $2 ]; then
        mkdir -p $2
    fi
    cp -r $1/* $2
}

## sortmerna
echo "SortMeRNA..."
sortmerna_dir=manipulate_rna/sortmerna
cd $tool_dir/$sortmerna_dir/sortmerna
./build.sh >> $current_dir/tmp/sortmerna_build
if grep "Error" $current_dir/tmp/sortmerna_build > /dev/null ; then
    echo "Error with build for sortmerna"
    exit
fi
cd $current_dir
create_copy_tool_dir $tool_dir/$sortmerna_dir $galaxy_tool_dir/$sortmerna_dir

## GenomeTools
echo "GenomeTools..."
genometools_dir=genometools/genometools/
if ! which gt > /dev/null; then 
    echo "GenomeTools..."
    echo -e "install GenomeTools on machine (needed to use reago)? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        cd $tool_dir/$genometools_dir
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
create_copy_tool_dir $tool_dir/$genometools_dir $galaxy_tool_dir/$genometools_dir

## reago
echo "Reago..."
reago_dir=manipulate_rna/reago/
create_copy_tool_dir $tool_dir/$reago_dir $galaxy_tool_dir/$reago_dir

## RDPTools
echo "RDPTools..."
rdptools_dir=RDPTools/
cd $tool_dir/$rdptools_dir/RDPTools
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
create_copy_tool_dir $tool_dir/$rdptools_dir $galaxy_tool_dir/$rdptools_dir

## cd-hit
echo "cd-hit..."
cd_hit_dir=cluster_sequences/cd-hit/
cd $tool_dir/$cd_hit_dir/cd-hit
if [ ! -f "cd-hit" ]; then 
    make openmp=no >> $current_dir/tmp/cd-hit_make
    if grep "Error" $current_dir/tmp/cd-hit_make > /dev/null ; then
        echo "Error with make for cd-hit"
        exit
    fi
else
    echo -e "  recompile? (y/n) \c"
    read 
    if [ $REPLY == "y" ]; then
        make clean
        make openmp=no >> $current_dir/tmp/cd-hit_make
        if grep "Error" $current_dir/tmp/cd-hit_make > /dev/null ; then
            echo "Error with make for cd-hit"
            exit
        fi
    fi
fi
cd $current_dir
create_copy_tool_dir $tool_dir/$cd_hit_dir $galaxy_tool_dir/$cd_hit_dir

## blast