#!/bin/bash
. src/misc/parse_yaml.sh
eval $(parse_yaml src/misc/config.yml "")

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

#humann2_databases --download chocophlan full databases/
if [[ ! -d databases/chocophlan/whole_db ]]; then
    mkdir databases/chocophlan/whole_db
fi

if [[ -f databases/chocophlan/whole_db/whole_db.ffn ]]; then
    rm databases/chocophlan/whole_db/g__whole.s__db.ffn
fi
touch databases/chocophlan/whole_db/g__whole.s__db.ffn

for i in $( ls databases/chocophlan )
do
    if [[ $i =~ \.gz$ ]]; then
        gunzip databases/chocophlan/$i
    fi
    cat databases/chocophlan/$i >> databases/chocophlan/whole_db/g__whole.s__db.ffn
done

#humann2_databases --download uniref diamond databases/

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
