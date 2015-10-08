#!/bin/bash

. ./src/prepare_galaxy_tools/functions.sh 

tool_dir=$1
galaxy_tool_dir=$2
current_dir=`pwd`

echo "Search similarity..."
create_tool_section_dir $galaxy_tool_dir/search_similarity

## blast
echo "Blast..."

#cd $galaxy_tool_dir/similarity_search/blast/
#if [ ! -d "ncbi-blast-2.2.31+-x64-linux/" ]; then
#    mkdir ncbi-blast-2.2.31+-x64-linux
#    curl -L -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-x64-linux.tar.gz | tar -C ncbi-blast-2.2.31+-x64-linux --strip-components=1 -xz
#fi
#if [ ! -d "ncbi-blast-2.2.31+-universal-macosx/" ]; then
#    mkdir ncbi-blast-2.2.31+-universal-macosx
#    curl -L -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-universal-macosx.tar.gz | tar -C ncbi-blast-2.2.31+-universal-macosx --strip-components=1 -xz
#fi
#cd $current_dir

