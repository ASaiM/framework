#!/bin/bash
. src/misc/parse_yaml.sh
. src/misc/generate_galaxy_ini.sh
. src/install_galaxy.sh

eval $(parse_yaml src/misc/config.yml "")

#if [ ! -d venv ]; then
#    echo "No virtual environment to activate"
#    echo -e "Relaunch it? (y/n)"
#    read 
#    if [ $REPLY == "y" ]; then
#        virtualenv venv
#        source venv/bin/activate
#        pip --no-cache-dir install -r requirements.txt
#        deactivate
#    fi
#fi
#source venv/bin/activate

to_do=$1
current_dir=$PWD

mkdir tmp

echo "Installing Galaxy"
echo "================="
# Getting the latest revision with wget from GitHub is faster than cloning it

cd $lib_dir/
if [[ ! -d $local_galaxy_dir ]]; then
    install_galaxy $local_galaxy_dir
fi
cd ../
echo ""

echo "Prepare galaxy tools"
echo "===================="
function create_symlink {
    if [ -e $1 ]; then
        if [ ! -L $1 ]; then
            rm -rf $1
            ln -s $2 $1
        fi
    else
        ln -s $2 $1
    fi 
}

if [[ ! -d $tool_playbook_dir/files/ ]]; then
    mkdir $tool_playbook_dir/files/
fi 

for i in $( ls ${tool_playbook_files_dir}/ )
do
    cp $tool_playbook_files_dir/$i $tool_playbook_dir/files/$i 
done

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
for i in $( ls $tool_data_dir )
do 
    create_symlink $galaxy_dir/tool-data/$i $PWD/$tool_data_dir/$i
done

# Dependencies
if [ ! -d $galaxy_dir/dependency_dir ]; then
    mkdir $galaxy_dir/dependency_dir
fi

# FTP
if [ ! -d $galaxy_dir/database/ftp ]; then
    mkdir $galaxy_dir/database/ftp
fi

# Web interface
cp $PWD/static/welcome.html $galaxy_dir/static/
cp $PWD/static/welcome.html $galaxy_dir/static/welcome.html.sample
for i in $( ls static/images/ )
do
    create_symlink $galaxy_dir/static/images/$i $PWD/static/images/$i
done

rm -rf tmp
echo ""

echo "Launch Galaxy"
echo "============="
cd $galaxy_dir
#sh manage_db.sh upgrade
#pip install -r requirements.txt
if [ $to_do == 'launch' ] ; then
    sh run.sh --daemon
elif [ $to_do == 'run_test' ] ; then
    sh run.sh --stop-daemon || true
    python scripts/fetch_eggs.py
    python ./scripts/functional_tests.py -v `python tool_list.py Continuous-Integration-Travis`
fi

source .venv/bin/activate
pip install -r $current_dir/requirements.txt

cd $current_dir
echo ""

echo "Populate with tools and workflows"
echo "================================="
./src/populate_galaxy.sh


echo "Populate with databases"
echo "======================="
./src/prepare_databases.sh
echo ""
