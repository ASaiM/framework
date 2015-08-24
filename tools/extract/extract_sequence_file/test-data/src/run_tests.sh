#!/bin/bash

input_data_dir="test-data/data/input/"
output_sequence_dir="test-data/data/output_sequence_file/"
output_information_dir="test-data/data/output_information_file/"
output_report_dir="test-data/data/output_report_file/"
output_qual_dir="test-data/data/output_qual_file/"

## Fasta format

echo "Read and write fasta file"
python extract_sequence_file.py \
    --input $input_data_dir/"fasta_file.fasta" \
    --custom_extraction_type "no" \
    --output_sequence $output_sequence_dir"fasta/read_write.fasta" \
    --report $output_report_dir"fasta/read_write.txt" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $input_data_dir/"fasta_file.fasta" \
    --obs_file $output_sequence_dir"fasta/read_write.fasta" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fasta/expected/read_write.txt" \
    --obs_file $output_report_dir"fasta/read_write.txt" \
    --comparison "Report file"

echo "Simple extraction of fasta file"
python extract_sequence_file.py \
    --input $input_data_dir/"fasta_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fasta/simple_extraction.txt" \
    --report $output_report_dir"fasta/simple_extraction.txt" \
    --to_extract "{id,length}" \
    --format "fasta"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fasta/expected/simple_extraction.txt" \
    --obs_file $output_report_dir"fasta/simple_extraction.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/simple_extraction.txt" \
    --obs_file $output_information_dir"fasta/simple_extraction.txt" \
    --comparison "Information file"

echo "Simple constraint of fasta file"
python extract_sequence_file.py \
    --input $input_data_dir/"fasta_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fasta/simple_constraint.txt" \
    --report $output_report_dir"fasta/simple_constraint.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fasta/expected/simple_constraint.txt" \
    --obs_file $output_report_dir"fasta/simple_constraint.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/simple_constraint.txt" \
    --obs_file $output_information_dir"fasta/simple_constraint.txt" \
    --comparison "Information file"

echo "Double constraints of fasta file"
python extract_sequence_file.py \
    --input $input_data_dir/"fasta_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fasta/double_constraint.txt" \
    --report $output_report_dir"fasta/double_constraint.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --constraint "id: in: test-data/data/id_in_list.txt" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fasta/expected/double_constraint.txt" \
    --obs_file $output_report_dir"fasta/double_constraint.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/double_constraint.txt" \
    --obs_file $output_information_dir"fasta/double_constraint.txt" \
    --comparison "Information file"

## Fastq format

echo "Read and write fastq file"
python extract_sequence_file.py \
    --input $input_data_dir/"fastq_file.fastq" \
    --custom_extraction_type "no" \
    --output_sequence $output_sequence_dir"fastq/read_write.fastq" \
    --report $output_report_dir"fastq/read_write.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $input_data_dir/"fastq_file.fastq" \
    --obs_file $output_sequence_dir"fastq/read_write.fastq" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fastq/expected/read_write.txt" \
    --obs_file $output_report_dir"fastq/read_write.txt" \
    --comparison "Report file"

echo "Read and split fastq file"
python extract_sequence_file.py \
    --input $input_data_dir/"fastq_file.fastq" \
    --custom_extraction_type "no" \
    --split "yes" \
    --quality_format "sanger" \
    --output_sequence $output_sequence_dir"fastq/read_split.fasta" \
    --output_quality $output_qual_dir"fastq/read_split.qual" \
    --report $output_report_dir"fastq/read_split.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $input_data_dir/"fasta_file.fasta" \
    --obs_file $output_sequence_dir"fastq/read_split.fasta" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $output_qual_dir"fastq/expected/read_split.qual" \
    --obs_file $output_qual_dir"fastq/read_split.qual" \
    --comparison "Quality file"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fastq/expected/read_split.txt" \
    --obs_file $output_report_dir"fastq/read_split.txt" \
    --comparison "Report file"

echo "Simple extraction of fastq file"
python extract_sequence_file.py \
    --input $input_data_dir/"fastq_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fastq/simple_extraction.txt" \
    --report $output_report_dir"fastq/simple_extraction.txt" \
    --to_extract "{id,length}" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fastq/expected/simple_extraction.txt" \
    --obs_file $output_report_dir"fastq/simple_extraction.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/simple_extraction.txt" \
    --obs_file $output_information_dir"fastq/simple_extraction.txt" \
    --comparison "Information file"

echo "Simple constraint of fastq file"
python extract_sequence_file.py \
    --input $input_data_dir/"fastq_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fastq/simple_constraint.txt" \
    --report $output_report_dir"fastq/simple_constraint.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fastq/expected/simple_constraint.txt" \
    --obs_file $output_report_dir"fastq/simple_constraint.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/simple_constraint.txt" \
    --obs_file $output_information_dir"fastq/simple_constraint.txt" \
    --comparison "Information file"

echo "Double constraint of fastq file"
python extract_sequence_file.py \
    --input $input_data_dir/"fastq_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $output_information_dir"fastq/double_constraint.txt" \
    --report $output_report_dir"fastq/double_constraint.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --constraint "id: in: test-data/data/id_in_list.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $output_report_dir"fastq/expected/double_constraint.txt" \
    --obs_file $output_report_dir"fastq/double_constraint.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $output_information_dir"/expected/double_constraint.txt" \
    --obs_file $output_information_dir"fastq/double_constraint.txt" \
    --comparison "Information file"