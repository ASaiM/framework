#!/bin/bash

input_data_dir="test-data/data/input/"
output_sequence_dir="test-data/data/output_sequence_file/"
output_information_dir="test-data/data/output_information_file/"
output_report_dir="test-data/data/output_report_file/"
output_qual_dir="test-data/data/output_qual_file/"

## Fasta format

echo "Read and write fasta file"
test_dir="test-data/data/read_write_fasta_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fasta" \
    --custom_extraction_type "no" \
    --output_sequence $test_dir/"output_sequence_file.fasta" \
    --report $test_dir"output_report.txt" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $test_dir/"input_sequence_file.fasta" \
    --obs_file $test_dir/"output_sequence_file.fasta" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"

echo "Simple extraction of fasta file"
test_dir="test-data/data/simple_extraction_fasta_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --format "fasta"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"

echo "Simple constraint of fasta file"
test_dir="test-data/data/simple_constraint_fasta_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"

echo "Double constraints of fasta file"
test_dir="test-data/data/double_constraint_fasta_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fasta" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --constraint "id: in: test-data/data/id_in_list.txt" \
    --format "fasta" 
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"

## Fastq format

echo "Read and write fastq file"
test_dir="test-data/data/read_write_fastq_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fastq" \
    --custom_extraction_type "no" \
    --output_sequence $test_dir/"output_sequence_file.fastq" \
    --report $test_dir"output_report.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $test_dir/"input_sequence_file.fastq" \
    --obs_file $test_dir/"output_sequence_file.fastq" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"

echo "Read and split fastq file"
test_dir="test-data/data/split_fastq_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fastq" \
    --custom_extraction_type "no" \
    --split "yes" \
    --quality_format "sanger" \
    --output_sequence $test_dir/"output_sequence_file.fasta" \
    --output_quality $test_dir/"output_quality.qual" \
    --report $test_dir"output_report.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $test_dir/"expected_output_sequence_file.fasta" \
    --obs_file $test_dir/"output_sequence_file.fasta" \
    --comparison "Sequence file"
python test-data/src/compare_files.py \
    --exp_file $test_dir/"output_quality.qual" \
    --obs_file $test_dir/"expected_output_quality.qual" \
    --comparison "Quality file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"

echo "Simple extraction of fastq file"
test_dir="test-data/data/simple_extraction_fastq_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"

echo "Simple constraint of fastq file"
test_dir="test-data/data/simple_constraint_fastq_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"

echo "Double constraint of fastq file"
test_dir="test-data/data/double_constraint_fastq_file/"
python extract_sequence_file.py \
    --input $test_dir/"input_sequence_file.fastq" \
    --custom_extraction_type "yes" \
    --output_information $test_dir"output_information.txt" \
    --report $test_dir"output_report.txt" \
    --to_extract "{id,length}" \
    --constraint "length: greater: 100" \
    --constraint "id: in: test-data/data/id_in_list.txt" \
    --format "fastq"
python test-data/src/compare_files.py \
    --exp_file $test_dir"/expected_output_report.txt" \
    --obs_file $test_dir"output_report.txt" \
    --comparison "Report file"
python test-data/src/compare_files.py \
    --exp_file $test_dir"expected_output_information.txt" \
    --obs_file $test_dir"output_information.txt" \
    --comparison "Information file"