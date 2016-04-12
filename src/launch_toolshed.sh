#!/usr/bin/env bash
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

echo "Configure ToolShed"
echo "=================="
# Configuration files
generate_toolshed_ini $toolshed_dir/config/tool_shed.ini

cd $toolshed_dir

launch_virtual_env
pip install -r $current_dir/requirements.txt

echo "Launch ToolShed"
echo "==============="
./run_tool_shed.sh --daemon

wait_until_up $toolshed_port $toolshed_dir/tool_shed_webapp.log