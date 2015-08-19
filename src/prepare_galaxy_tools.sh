#!/bin/sh

galaxy_dir=$1
galaxy_tool_dir=$galaxy_dir/tools/docker
tool_dir=tools


mkdir -p $galaxy_tool_dir

# Extraction of similarity search report
extract_similarity_search_report_dir=$tool_dir/extract/extract_similarity_search_report
sudo docker build -t asaim/extract-similarity-search-report $extract_similarity_search_report_dir
cp $extract_similarity_search_report_dir/extract_similarity_search_report.xml $galaxy_tool_dir/extract_similarity_search_report.xml

mkdir $galaxy_tool_dir/extract_similarity_search_report_2
cp $tool_dir/extract/extract_similarity_search_report_2/extract_similarity_search_report.py $galaxy_tool_dir/extract_similarity_search_report_2/extract_similarity_search_report.py
cp $tool_dir/extract/extract_similarity_search_report_2/extract_similarity_search_report.xml $galaxy_tool_dir/extract_similarity_search_report_2/extract_similarity_search_report.xml

# CatDocker
cp $tool_dir/catDocker/catDocker.xml $galaxy_tool_dir/catDocker.xml
