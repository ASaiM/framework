#!/bin/bash

db_dir=$1
current_dir=`pwd`

echo "Prepare SortMeRNA databases..."
sortmerna_db_dir = $galaxy_dir/dependency_dir/sortmerna/2.0/bebatut/sortmerna/2df1aeb371fb/rRNA_databases/
indexdb_rna --ref $sortmerna_dir/rfam-5.8s-id98.fasta,$sortmerna_dir/rfam-5.8s-id98
indexdb_rna --ref $sortmerna_dir/rfam-5s-database-id98.fasta,$sortmerna_dir/rfam-5s-database-id98
indexdb_rna --ref $sortmerna_dir/silva-arc-16s-id95.fasta,$sortmerna_dir/silva-arc-16s-id95
indexdb_rna --ref $sortmerna_dir/silva-arc-23s-id98.fasta,$sortmerna_dir/silva-arc-23s-id98
indexdb_rna --ref $sortmerna_dir/silva-bac-16s-id90.fasta,$sortmerna_dir/silva-bac-16s-id90
indexdb_rna --ref $sortmerna_dir/silva-bac-23s-id98.fasta,$sortmerna_dir/silva-bac-23s-id98
indexdb_rna --ref $sortmerna_dir/silva-euk-18s-id95.fasta,$sortmerna_dir/silva-euk-18s-id95
indexdb_rna --ref $sortmerna_dir/silva-euk-28s-id98.fasta,$sortmerna_dir/silva-euk-28s-id98
echo ""


## retrieve cog, extract info and formate for use with humann
echo "COG downloading, extracting and formating..."
cog_dir=$db_dir/cog/
if [ ! -e $cog_dir/raw_data/prot2003-2014.fa ]; then
    python $cog_dir/src/download_database.py \
        --raw_data_dir $cog_dir/raw_data/
fi
if [ ! -e $cog_dir/extracted_data/genels.gz ]; then
    python $cog_dir/src/extract_cog_data.py \
        --raw_data_dir $cog_dir/raw_data/ \
        --extracted_data_dir $cog_dir/extracted_data/
fi
echo ""
