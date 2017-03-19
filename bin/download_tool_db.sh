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

echo ""
echo "Prepare MetaPhlan2 and HUMAnN2 db"
echo ""
python /usr/bin/launch_data_managers.py

# Prepare MetaPhlAn db
#mkdir /databases/db_v20
#sed -i.bak 's/#mpa_v20_m200/mpa_v20_m200/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/bebatut/metaphlan2/8991e05c44e4/metaphlan2_db.loc
#sed -i.bak 's/$METAPHLAN2_DIR/\/databases/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/bebatut/metaphlan2/8991e05c44e4/metaphlan2_db.loc
#
#wget https://bitbucket.org/biobakery/metaphlan2/get/2.5.0.zip
#unzip 2.5.0.zip
#mv biobakery-metaphlan2-6f2a1673af85/db_v20/* /databases/db_v20/
#rm 2.5.0.zip
#rm -rf biobakery-metaphlan2-6f2a1673af85
#
## Prepare HUMAnN db
#/tool_deps/_conda/envs/__humann2@0.6.1/bin/humann2_databases --download chocophlan full /databases
#/tool_deps/_conda/envs/__humann2@0.6.1/bin/humann2_databases --download uniref diamond /databases