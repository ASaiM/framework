#!/usr/bin/env bash
. src/misc.sh

generate_tools_yml $tool_playbook_dir/tools.yml

source $galaxy_dir/.venv/bin/activate

current_dir=$PWD

echo "Populate with tools..."
cd $tool_playbook_dir
ansible-playbook tools.yml -i "localhost,"
cd $current_dir
echo ""


echo "Populate with workflows..."
for i in $( ls $workflow_dir/*.ga )
do
    echo $i
    workflow_path=$workflow_dir"/"$i
    python ./src/integrate_workflow_in_gi.py \
        --workflow_path $i \
        --gi_url "http://"$host":"$port \
        --api_key $master_api_key
done