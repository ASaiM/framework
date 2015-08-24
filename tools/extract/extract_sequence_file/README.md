Extract from sequence file
==========================

This tool is developped to extract from sequence file. Different treatments are possible.
Specific sequences could be extracted given some constraints and they could be saved in a sequence file. 
Some information about the sequences such as the identifiant or the length could be extracted and saved in
a text file. Fastq file could also be split into a sequence file and a quality file.

# Usage

```
python extract_sequence_file.py \
    --input input_sequence_filepath \
    --format fastq/fasta
    --custom_extraction_type yes/no \
    [--output_sequence output_sequence_filepath if custom_extraction_type = no] \
    [--output_information information_filepath if custom_extraction_type = yes] \
    [--to_extract "{info_to_extract,info_to_extract}" if custom_extraction_type = yes] \
    [--split yes/no if format=fastq] \
    [--output_quality output_quality_filepath if split=yes] \
    [--quality_format sanger/solexa/illumina_1_3/illumina_1_5/illumina_1_8 if split=yes] \
    --report report_filepath \
    [--constraint info_to_constrain: type_of_constraint: value_of_constraint ]
```
# Formats

Formats for sequence file: 

- fasta 
- fastq

Formats for quality scores:

- sanger
- solexa
- illumina_1_3
- illumina_1_5
- illumina_1_8 

# Functional tests

Some functional tests are implemented tot est the major treatments. To launch functional tests:

```
test-data/src/run_tests.sh
```
