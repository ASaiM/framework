#!/bin/bash
. src/misc/parse_yaml.sh

eval $(parse_yaml src/misc/config.yml "")


echo "Installing Galaxy"
echo "================="
# Getting the latest revision with wget from GitHub is faster than cloning it
function install_galaxy {
    wget https://codeload.github.com/galaxyproject/galaxy/tar.gz/master
    tar -zxvf master --transform 's/'$local_galaxy_dir'/'$local_toolshed_dir'/' | tail
    rm master
}
cd $lib_dir/
if [[ ! -d $local_galaxy_dir ]]; then
    install_galaxy
fi
cd ../
echo ""

toolshed_dir=$lib_dir/$local_toolshed_dir

echo "Configure Galaxy"
echo "================"
# Configuration files
cp $PWD/$galaxy_conf_file_dir/tool_shed.ini $toolshed_dir/config/tool_shed.ini

cd $toolshed_dir
./run_tool_shed.sh