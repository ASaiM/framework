#!/bin/bash

galaxy_dir=$1
galaxy_tool_dir=$galaxy_dir/tools/
current_dir=`pwd`
db_dir=/db/

## prinseq
prinseq_dir=$galaxy_tool_dir/quality_control/prinseq
mkdir -p $prinseq_dir/src
curl -L -s http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz | tar -C $prinseq_dir/src/ --strip-components=1 -xz

## metaphlan 2
#metaphlan_dir=$galaxy_tool_dir/non_rRNA_taxonomic_assignation/metaphlan
#hg clone https://bitbucket.org/biobakery/metaphlan2 $metaphlan_dir/src

## humann 2
#humann2_dir=$galaxy_dir/metabolic_analysis/humann2
#cd $humann2_dir 
#hg clone https://bitbucket.org/biobakery/humann2 
#cd humann2 
#python setup.py install 
#cd $current_dir

## humann 
humann_dir=$galaxy_tool_dir/metabolic_analysis/humann
cd $humann_dir
if [ ! -d "humann/" ]; then
    hg clone https://bitbucket.org/biobakery/humann
fi
cd $current_dir

## retrieve cog, extract info and formate for use with humann
python data/db/cog/src/download_database.py \
    --raw_data_dir data/db/cog/raw_data/
python data/db/cog/src/extract_cog_data.py \
    --raw_data_dir data/db/cog/raw_data/ \
    --extracted_data_dir data/db/cog/extracted_data/
python data/db/cog/src/formate_database_for_humann.py \
    --raw_data_dir data/db/cog/raw_data/ \
    --extracted_data_dir data/db/cog/extracted_data/ \
    --humann_formated_data_dir data/db/cog/humann_formated_data/ \
    --humann_dir $humann_dir/humann/





