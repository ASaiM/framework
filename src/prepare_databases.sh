#!/bin/bash
. src/parse_yaml.sh
eval $(parse_yaml src/misc/config.yml "")

db_dir=$1
current_dir=$PWD

echo "Prepare SortMeRNA databases..."
sortmerna_db_dir=$galaxy_dir/dependency_dir/sortmerna/2.0/bebatut/sortmerna/a6dc642c751a/rRNA_databases/
cd $sortmerna_db_dir
indexdb_rna --ref rfam-5.8s-database-id98.fasta,rfam-5.8s-database-id98
indexdb_rna --ref rfam-5s-database-id98.fasta,rfam-5s-database-id98
indexdb_rna --ref silva-arc-16s-id95.fasta,silva-arc-16s-id95
indexdb_rna --ref silva-arc-23s-id98.fasta,silva-arc-23s-id98
indexdb_rna --ref silva-bac-16s-id90.fasta,silva-bac-16s-id90
indexdb_rna --ref silva-bac-23s-id98.fasta,silva-bac-23s-id98
indexdb_rna --ref silva-euk-18s-id95.fasta,silva-euk-18s-id95
indexdb_rna --ref silva-euk-28s-id98.fasta,silva-euk-28s-id98
cd $current_dir
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
