#!/bin/bash
. src/misc.sh

source $galaxy_dir/.venv/bin/activate

current_dir=$PWD

gi_url="http://"$host":"$port

echo "Prepare SortMeRNA databases..."
declare RESULT=($(python $src_prepare/get_installed_tool_info.py \
    --tool_name "sortmerna" \
    --tool_shed "testtoolshed.g2.bx.psu.edu" \
    --gi_url $gi_url \
    --api_key $master_api_key))
revision=${RESULT[0]}
owner=${RESULT[1]}
sortmerna_db_dir=$galaxy_dir/dependency_dir/sortmerna/2.0/$owner/sortmerna/$revision/rRNA_databases/

cd $sortmerna_db_dir
../bin/indexdb_rna --ref rfam-5.8s-database-id98.fasta,rfam-5.8s-database-id98
../bin/indexdb_rna --ref rfam-5s-database-id98.fasta,rfam-5s-database-id98
../bin/indexdb_rna --ref silva-arc-16s-id95.fasta,silva-arc-16s-id95
../bin/indexdb_rna --ref silva-arc-23s-id98.fasta,silva-arc-23s-id98
../bin/indexdb_rna --ref silva-bac-16s-id90.fasta,silva-bac-16s-id90
../bin/indexdb_rna --ref silva-bac-23s-id98.fasta,silva-bac-23s-id98
../bin/indexdb_rna --ref silva-euk-18s-id95.fasta,silva-euk-18s-id95
../bin/indexdb_rna --ref silva-euk-28s-id98.fasta,silva-euk-28s-id98
cd $current_dir
echo ""

echo "Prepare HUMAnN2 databases..."
declare RESULT=($(python $src_prepare/get_installed_tool_info.py \
    --tool_name "package_humann_2_0" \
    --tool_shed "testtoolshed.g2.bx.psu.edu" \
    --gi_url $gi_url \
    --api_key $master_api_key))
revision=${RESULT[0]}
owner=${RESULT[1]}
humann2_db_dir=$galaxy_dir/dependency_dir/humann2/2.0/$owner/package_humann_2_0/$revision/

cd $humann2_db_dir
if [ ! -d "databases/chocophlan" ]; then
    humann2_databases --download chocophlan full databases/
fi
if [ ! -d "databases/uniref" ]; then
    humann2_databases --download uniref diamond databases/
fi
cd $current_dir
echo ""

## retrieve Greengenes for QIIME
echo "Prepare QIIME databases..."
declare RESULT=($(python $src_prepare/get_installed_tool_info.py \
    --tool_name "qiime" \
    --gi_url $gi_url \
    --api_key $master_api_key))
revision=${RESULT[0]}
owner=${RESULT[1]}
qiime_dir=$galaxy_dir/dependency_dir/qiime/1.9.1/$owner/qiime/$revision
cd $qiime_dir

if [ ! -d "databases" ]; then
    mkdir "databases"
fi
cd "databases"

echo "  Greengenes downloading, extracting and formating..."
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
tar xzf gg_13_8_otus.tar.gz
rm gg_13_8_otus.tar.gz

echo "  SILVA downloading, extracting and formating..."
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
tar xzf gg_13_8_otus.tar.gz
rm gg_13_8_otus.tar.gz
