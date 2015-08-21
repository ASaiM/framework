#!/bin/bash

python extract_sequence_file.py \
    --input "test-data/data/input/fasta_file.fasta" \
    --format "fasta" \ 
    --custom_extraction_type "no" \
    --output_sequence "test-data/data/output_sequence_file/fasta/simple_extraction.fasta"
    --report "test-data/data/output_report_file/fasta/simple_extraction.txt"

