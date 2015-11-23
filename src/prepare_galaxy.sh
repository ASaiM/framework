#!/bin/bash

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

to_do=$1
current_dir=$PWD
lib_dir=lib

mkdir tmp

# Installing Galaxy
# =================
# Getting the latest revision with wget from GitHub is faster than cloning it
function install_galaxy {
    wget https://codeload.github.com/galaxyproject/galaxy/tar.gz/master
    tar -zxvf master | tail
    rm master
}
cd $lib_dir/
galaxy_dir=galaxy-master
if [[ -d $galaxy_dir ]]; then
    if [[ $2 == '--reset' ]]; then
        rm -rf $galaxy_dir
        install_galaxy
    fi
else
    install_galaxy
fi
cd ../

galaxy_dir=$lib_dir/$galaxy_dir
galaxy_tool_dir=$galaxy_dir/tools/

# Prepare databases
# =================
db_dir=data/db/
./src/prepare_databases.sh $db_dir

# Prepare galaxy tools
# ====================
tool_dir=$lib_dir/galaxy_tools/
./src/prepare_galaxy_tools.sh $galaxy_tool_dir $tool_dir $db_dir

tool_dir=$PWD/$tool_dir
galaxy_tool_dir=$PWD/$galaxy_tool_dir
for i in $( ls ${tool_dir}/ )
do
    if [ $i == 'extract' ]; then
        create_symlink $galaxy_dir/tools/$i/extract_sequence_file \
            $tool_dir/$i/extract_sequence_file
        create_symlink $galaxy_dir/tools/$i/extract_similarity_search_report \
            $tool_dir/$i/extract_similarity_search_report
    else
        create_symlink $galaxy_dir/tools/$i $tool_dir/$i
    fi 
done

# Configure Galaxy
# ================
# Configuration files
for i in $( ls config/ )
do
    create_symlink $galaxy_dir/config/$i $PWD/config/$i
done

# Tool data
for i in $( ls data/tool-data/ )
do 
    create_symlink $galaxy_dir/tool-data/$i $PWD/data/tool-data/$i
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

# Launch Galaxy
# =============
cd $galaxy_dir
if [ $to_do == 'launch' ] ; then
    sh run.sh >> run_galaxy
elif [ $to_do == 'run_test' ] ; then
    ./run.sh --stop-daemon || true
    python scripts/fetch_eggs.py
    python ./scripts/functional_tests.py -v `python tool_list.py Continuous-Integration-Travis`
fi