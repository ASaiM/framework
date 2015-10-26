#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

galaxy_tool_dir=$1
tool_dir=$2
db_dir=$3
current_dir=`pwd`

section_dir=analyze_metabolism

current_dir=`pwd`

echo "Analyze metabolism..."
create_tool_section_dir $galaxy_tool_dir/$section_dir

## humann 2
#humann2_dir=$galaxy_dir/metabolic_analysis/humann2
#cd $humann2_dir 
#hg clone https://bitbucket.org/biobakery/humann2 
#cd humann2 
#python setup.py install 
#cd $current_dir

## humann 
echo " HUMAnN..."
humann_dir=$section_dir/humann
create_copy_tool_dir $tool_dir/$humann_dir $galaxy_tool_dir/$humann_dir
cd $galaxy_tool_dir/$humann_dir
if [ ! -d "humann/" ]; then
    echo "  cloning"
    hg clone https://bitbucket.org/biobakery/humann
    cd humann/
    mkdir original_data/
    cp data/* original_data/
    cp SConstruct original_data/
    cp $current_dir/data/db/metacyc/meta.tar.gz data/  
    
    scons >> $current_dir/tmp/humann_initial_scons 
    cd data/MinPath/glpk-4.6/
    autoconf >> $current_dir/tmp/humann_glpk_autoconf
    if grep "Error" $current_dir/tmp/humann_autoconf > /dev/null ; then
        echo "Error with autoconf for glpk in humann"
        exit
    fi

    ./configure >> $current_dir/tmp/humann_glpk_configure
    if grep "Error" $current_dir/tmp/humann_glpk_configure > /dev/null ; then
        echo "Error with configure for glpk in humann"
        exit
    fi

    make clean >> $current_dir/tmp/humann_glpk_make_clean
    if grep "Error" $current_dir/tmp/humann_make_clean > /dev/null ; then
        echo "Error with make clean for glpk in humann"
        exit
    fi

    make >> $current_dir/tmp/humann_glpk_make
    if grep "Error" $current_dir/tmp/humann_glpk_make > /dev/null ; then
        echo "Error with make for glpk in humann"
        exit
    fi    
else
    echo "  updating"
    cd humann/
    hg pull
fi
cd $current_dir

cog_dir=$db_dir/cog/
if [ ! -e $cog_dir/humann_formated_data/map_kegg.txt ]; then
    python $cog_dir/src/formate_database_for_humann.py \
        --raw_data_dir $cog_dir/raw_data/ \
        --extracted_data_dir $cog_dir/extracted_data/ \
        --humann_formated_data_dir $cog_dir/humann_formated_data/ \
        --humann_dir $galaxy_tool_dir/$humann_dir/humann/
fi
if [ ! -d $galaxy_tool_dir/$humann_dir/humann/cog_data/ ]; then
    mkdir $galaxy_tool_dir/$humann_dir/humann/cog_data/
fi
cp $db_dir/cog/humann_formated_data/* $galaxy_tool_dir/$humann_dir/humann/cog_data/
cp $db_dir/cog/extracted_data/refseq_orga_id_correspondance $galaxy_tool_dir/$humann_dir/humann/cog_data/