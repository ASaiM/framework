#!/bin/bash

galaxy_dir=$1
galaxy_tool_dir=$galaxy_dir/tools/
tool_dir=tools

# Quality control
galaxy_quality_control_tool_dir=$galaxy_tool_dir/quality_control/
quality_control_tool_dir=$tool_dir/quality_control

## prinseq
galaxy_prinseq_dir=$galaxy_quality_control_tool_dir/prinseq
prinseq_dir=$quality_control_tool_dir/prinseq

mkdir -p $galaxy_prinseq_dir/src
mkdir -p $prinseq_dir/src/
curl -L -s http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz | tar -C $prinseq_dir/src/ --strip-components=1 -xz
cp $prinseq_dir/prinseq.xml $galaxy_prinseq_dir/prinseq.xml
cp -r $prinseq_dir/src/ $galaxy_prinseq_dir/src

# Extraction tools
galaxy_extract_tool_dir=$galaxy_tool_dir/extract/
extract_tool_dir=$tool_dir/extract

## Extraction of sequence file
galaxy_extract_sequence_file_dir=$galaxy_extract_tool_dir/extract_sequence_file
extract_sequence_file_dir=$extract_tool_dir/extract_sequence_file

mkdir -p $galaxy_extract_sequence_file_dir
cp $extract_sequence_file_dir/extract_sequence_file.py $galaxy_extract_sequence_file_dir/extract_sequence_file.py
cp $extract_sequence_file_dir/extract_sequence_file.xml $galaxy_extract_sequence_file_dir/extract_sequence_file.xml

cp -r $extract_sequence_file_dir/test-data/data/read_write_fasta_file/ $galaxy_dir/test-data/read_write_fasta_file
cp -r $extract_sequence_file_dir/test-data/data/simple_extraction_fasta_file/ $galaxy_dir/test-data/simple_extraction_fasta_file
cp -r $extract_sequence_file_dir/test-data/data/simple_constraint_fasta_file/ $galaxy_dir/test-data/simple_constraint_fasta_file
cp -r $extract_sequence_file_dir/test-data/data/double_constraint_fasta_file/ $galaxy_dir/test-data/double_constraint_fasta_file
cp -r $extract_sequence_file_dir/test-data/data/read_write_fastq_file/ $galaxy_dir/test-data/read_write_fastq_file
cp -r $extract_sequence_file_dir/test-data/data/split_fastq_file/ $galaxy_dir/test-data/split_fastq_file
cp -r $extract_sequence_file_dir/test-data/data/simple_extraction_fastq_file/ $galaxy_dir/test-data/simple_extraction_fastq_file
cp -r $extract_sequence_file_dir/test-data/data/simple_constraint_fastq_file/ $galaxy_dir/test-data/simple_constraint_fastq_file
cp -r $extract_sequence_file_dir/test-data/data/double_constraint_fastq_file/ $galaxy_dir/test-data/double_constraint_fastq_file

## Extraction of similarity search report
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


