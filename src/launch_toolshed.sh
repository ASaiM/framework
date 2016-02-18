#!/bin/bash
. src/misc.sh

current_dir=$PWD

echo "Installing Galaxy"
echo "================="
cd $lib_dir/
if [[ ! -d $local_toolshed_dir ]]; then
    install_galaxy $local_toolshed_dir "toolshed"
fi
cd ../
echo ""

toolshed_dir=$lib_dir/$local_toolshed_dir

echo "Configure ToolShed"
echo "=================="
# Configuration files
generate_toolshed_ini $toolshed_dir/config/tool_shed.ini

cd $toolshed_dir
./run_tool_shed.sh --daemon

source .venv/bin/activate
pip install -r $current_dir/requirements.txt

