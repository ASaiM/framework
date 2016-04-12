#!/usr/bin/env bash
. src/misc.sh

to_do=$1
current_dir=$PWD

mkdir tmp

if [[ ! -d $lib_dir ]]; then
    mkdir -p $lib_dir 
fi

echo "Installing Galaxy"
echo "================="
# Getting the latest revision with wget from GitHub is faster than cloning it

cd $lib_dir/
if [[ ! -d $local_galaxy_dir ]]; then
    install_galaxy $local_galaxy_dir
fi
cd $current_dir
echo ""

echo "Prepare galaxy tools playbook"
echo "============================="
cd $lib_dir/
wget https://github.com/galaxyproject/ansible-galaxy-tools/archive/v0.2.0.zip
unzip v0.2.0.zip
rm v0.2.0.zip
cd $current_dir

mv $lib_dir/ansible-galaxy-tools-0.2.0 $tool_playbook_dir
cp $chosen_tool_dir/common_tool_list.yaml $tool_playbook_dir/files/
cp $chosen_tool_dir/functional_assignation_tool_list.yaml $tool_playbook_dir/files/
cp $chosen_tool_dir/posttreatments_tool_list.yaml $tool_playbook_dir/files/
cp $chosen_tool_dir/pretreatments_tool_list.yaml $tool_playbook_dir/files/
cp $chosen_tool_dir/taxonomic_assignation_tool_list.yaml $tool_playbook_dir/files/
echo ""

echo "Configure Galaxy"
echo "================"
# Configuration files
for i in $( ls $galaxy_conf_file_dir )
do
    if [[ $i != "galaxy.ini" ]]; then
        cp $PWD/$galaxy_conf_file_dir/$i $galaxy_dir/config/$i 
    fi
done
generate_galaxy_ini $galaxy_dir/config/galaxy.ini

#cp data/text.py $galaxy_dir/lib/galaxy/datatypes/text.py

# Tool data
wget https://raw.githubusercontent.com/bgruening/galaxytools/8b913a72a9f6ef1553859cc29a97943095010a2d/tools/rna_tools/sortmerna/tool-data/rRNA_databases.loc.sample 
mv rRNA_databases.loc.sample $galaxy_dir/tool-data

wget https://raw.githubusercontent.com/ASaiM/galaxytools/7d55a32cde6151a393c3a43960f2f0afdef5182a/tools/metaphlan2/tool-data/metaphlan2_metadata.loc.sample
mv metaphlan2_metadata.loc.sample $galaxy_dir/tool-data
wget https://raw.githubusercontent.com/ASaiM/galaxytools/7d55a32cde6151a393c3a43960f2f0afdef5182a/tools/metaphlan2/tool-data/metaphlan2_bowtie_db.loc.sample
mv metaphlan2_bowtie_db.loc.sample $galaxy_dir/tool-data

wget https://raw.githubusercontent.com/ASaiM/galaxytools/ad6e42b47bab92dd9c25c263ce3da7625468985b/tools/humann2/tool-data/humann2_nucleotide_database.loc.sample
mv humann2_nucleotide_database.loc.sample $galaxy_dir/tool-data
wget https://raw.githubusercontent.com/ASaiM/galaxytools/ad6e42b47bab92dd9c25c263ce3da7625468985b/tools/humann2/tool-data/humann2_protein_database.loc.sample
mv humann2_protein_database.loc.sample $galaxy_dir/tool-data

wget https://raw.githubusercontent.com/peterjc/galaxy_blast/49f5fe70fdb24b284dcfc90cfcddc84942aca9ab/tool-data/blastdb_d.loc.sample
mv blastdb_d.loc.sample $galaxy_dir/tool-data
wget https://raw.githubusercontent.com/peterjc/galaxy_blast/49f5fe70fdb24b284dcfc90cfcddc84942aca9ab/tool-data/blastdb_p.loc.sample
mv blastdb_p.loc.sample $galaxy_dir/tool-data
wget https://raw.githubusercontent.com/peterjc/galaxy_blast/49f5fe70fdb24b284dcfc90cfcddc84942aca9ab/tool-data/blastdb.loc.sample
mv blastdb.loc.sample $galaxy_dir/tool-data

# Dependencies
if [ ! -d $galaxy_dir/dependency_dir ]; then
    mkdir $galaxy_dir/dependency_dir
fi

# FTP
if [ ! -d $galaxy_dir/database/ftp ]; then
    mkdir $galaxy_dir/database/ftp
fi

# Web interface
cp $data_dir/static/welcome.html $galaxy_dir/static/
cp $data_dir/static/welcome.html $galaxy_dir/static/welcome.html.sample
for i in $( ls $data_dir/images/ )
do
    cp $data_dir/images/$i $galaxy_dir/static/images/$i 
done

rm -rf tmp
echo ""

echo "Move to Galaxy repository"
echo "========================="
cd $galaxy_dir
echo ""

#launch_virtual_env
#pip install -r $current_dir/requirements.txt

echo "Launch Galaxy"
echo "============="
sh run.sh --daemon

cd $current_dir
echo ""


