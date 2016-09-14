#!/usr/bin/env bash
. src/misc.sh

generate_tools_yml $tool_playbook_dir/tools.yml

source $galaxy_dir/.venv/bin/activate

current_dir=$PWD

echo "Populate with tools..."
cd $tool_playbook_dir
ansible-playbook tools.yml -vvv -i "localhost,"
cd $current_dir
echo ""

gi_url="http://"$host":"$port

declare RESULT=($(python $src_prepare/get_installed_tool_info.py \
    --tool_name "package_samtools_1_2" \
    --tool_shed "toolshed.g2.bx.psu.edu" \
    --gi_url "$gi_url" \
    --api_key $master_api_key))
revision=${RESULT[0]}
owner=${RESULT[1]}
ln -s $galaxy_dir/dependency_dir/samtools/1.2/$owner/package_samtools_1_2/$revision/bin/samtools $galaxy_dir/.venv/bin/samtools
