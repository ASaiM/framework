#!/bin/bash
. src/misc/parse_yaml.sh
eval $(parse_yaml src/misc/config.yml "")

source $galaxy_dir/.venv/bin/activate

current_dir=$PWD

echo "Prepare SortMeRNA databases..."
revision=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/pretreatments_tool_list.yaml \
    --tool_name sortmerna \
    --tool_function get_revision_number`
owner=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/pretreatments_tool_list.yaml \
    --tool_name sortmerna \
    --tool_function get_owner`
sortmerna_db_dir=$galaxy_dir/dependency_dir/sortmerna/2.0/$owner/sortmerna/$revision/rRNA_databases/
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

echo "Prepare HUMAnN2 databases..."
revision=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name humann2 \
    --tool_function get_revision_number`
owner=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name humann2 \
    --tool_function get_owner`
humann2_db_dir=$galaxy_dir/dependency_dir/humann2/2.0/$owner/humann2/$revision/
cd $humann2_db_dir

humann2_databases --download chocophlan full databases/
humann2_databases --download uniref diamond databases/

cd $current_dir
echo ""

## retrieve Greengenes for QIIME
echo "Greengenes downloading, extracting and formating..."
revision=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name qiime \
    --tool_function get_revision_number`
owner=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name qiime \
    --tool_function get_owner`
greengenes_dir=$galaxy_dir/dependency_dir/qiime/1.9.1/$owner/qiime/$revision/databases
cd $greengenes_dir
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
tar xzf gg_13_8_otus.tar.gz
rm gg_13_8_otus.tar.gz

## retrieve SILVA for QIIME
echo "SILVA downloading, extracting and formating..."
revision=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name qiime \
    --tool_function get_revision_number`
owner=`python src/misc/parse_tool_playbook_yaml.py \
    --file $tool_playbook_files_dir/functional_assignation_tool_list.yaml \
    --tool_name qiime \
    --tool_function get_owner`
silva_dir=$galaxy_dir/dependency_dir/qiime/1.9.1/$owner/qiime/$revision/databases
silva_dir=$db_dir/greengenes/
cd $silva_dir
#wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
#tar xzf gg_13_8_otus.tar.gz
#rm gg_13_8_otus.tar.gz