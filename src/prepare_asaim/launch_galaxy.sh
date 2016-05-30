#!/usr/bin/env bash
. src/misc.sh

run_parameters=$1
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
if [[ ! -d $tool_playbook_dir ]]; then
    mkdir $tool_playbook_dir
fi
if [[ ! -d $tool_playbook_dir/roles ]]; then
    mkdir $tool_playbook_dir/roles
fi
if [[ ! -d $tool_playbook_dir/files ]]; then
    mkdir $tool_playbook_dir/files
fi

git clone https://github.com/galaxyproject/ansible-galaxy-tools.git $tool_playbook_dir/roles/ansible-galaxy-tools
cp $chosen_tool_dir/common_tool_list.yaml $tool_playbook_dir/roles/ansible-galaxy-tools/files/
cp $chosen_tool_dir/seq_preparation_tool_list.yaml $tool_playbook_dir/roles/ansible-galaxy-tools/files/
cp $chosen_tool_dir/metagenomic_tool_list.yaml $tool_playbook_dir/roles/ansible-galaxy-tools/files/
cp $chosen_tool_dir/posttreatments_tool_list.yaml $tool_playbook_dir/roles/ansible-galaxy-tools/files/
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
uncomment_last_lines rRNA_databases.loc.sample $galaxy_dir/tool-data/rRNA_databases.loc.sample 8
rm rRNA_databases.loc.sample

https://raw.githubusercontent.com/ASaiM/galaxytools/master/tools/metaphlan2/tool-data/metaphlan2_db.loc.sample

wget https://raw.githubusercontent.com/ASaiM/galaxytools/88ce150a6e2b37bbd4babe08b5b2bf0faed0a0e8/tools/metaphlan2/tool-data/metaphlan2_db.loc.sample
uncomment_last_lines metaphlan2_db.loc.sample $galaxy_dir/tool-data/metaphlan2_db.loc.sample 1
rm metaphlan2_db.loc.sample

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

launch_virtual_env
pip install -r $current_dir/requirements.txt

echo "Launch Galaxy"
echo "============="
sh run.sh $run_parameters

cd $current_dir
echo ""


