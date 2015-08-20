#!/bin/bash

galaxy_dir=$1
galaxy_tool_dir=$galaxy_dir/tools/
tool_dir=tools

# Extraction tools
galaxy_extract_tool_dir=$galaxy_tool_dir/extract/
extract_tool_dir=$tool_dir/extract
# Extraction of similarity search report
galaxy_extract_similarity_search_report_dir=$galaxy_extract_tool_dir/extract_similarity_search_report
extract_similarity_search_report_dir=$extract_tool_dir/extract_similarity_search_report
mkdir -p $galaxy_extract_similarity_search_report_dir
cp $extract_similarity_search_report_dir/extract_similarity_search_report.py $galaxy_extract_similarity_search_report_dir/extract_similarity_search_report.py
cp $extract_similarity_search_report_dir/extract_similarity_search_report.xml $galaxy_extract_similarity_search_report_dir/extract_similarity_search_report.xml

#if [[ "$OSTYPE" == "linux-gnu" ]]; then
#    sudo docker build -t asaim/extract-similarity-search-report $extract_similarity_search_report_dir
#elif [[ "$OSTYPE" == "darwin"* ]] ; then
#    docker build -t asaim/extract-similarity-search-report $extract_similarity_search_report_dir
#else 
#    echo "unknown"
#    exit
#fi


