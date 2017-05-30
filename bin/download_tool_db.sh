#!/usr/bin/env bash

mkdir /databases

# Prepare SortMeRNA db
echo ""
echo "Prepare SortMeRNA db"
echo ""
mkdir /databases/rRNA_databases
sed -i.bak 's/#rfam/rfam/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc
sed -i.bak 's/#silva/silva/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc
sed -i.bak 's/$SORTMERNADIR/\/databases/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc

wget https://github.com/biocore/sortmerna/archive/2.1b.tar.gz
tar xzf 2.1b.tar.gz
mv sortmerna-2.1b/rRNA_databases/* /databases/rRNA_databases
rm 2.1b.tar.gz
rm -rf sortmerna-2.1b/
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/rfam-5.8s-database-id98.fasta,/databases/rRNA_databases/rfam-5.8s-database-id98
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/rfam-5s-database-id98.fasta,/databases/rRNA_databases/rfam-5s-database-id98
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-arc-16s-id95.fasta,/databases/rRNA_databases/silva-arc-16s-id95
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-arc-23s-id98.fasta,/databases/rRNA_databases/silva-arc-23s-id98
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-bac-16s-id90.fasta,/databases/rRNA_databases/silva-bac-16s-id90
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-bac-23s-id98.fasta,/databases/rRNA_databases/silva-bac-23s-id98
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-euk-18s-id95.fasta,/databases/rRNA_databases/silva-euk-18s-id95
/tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-euk-28s-id98.fasta,/databases/rRNA_databases/silva-euk-28s-id98
echo ""