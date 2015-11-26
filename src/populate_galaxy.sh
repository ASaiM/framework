#!/bin/bash
. src/parse_yaml.sh
. src/misc/generate_tools_yml.sh

eval $(parse_yaml src/misc/config.yml "")

generate_tools_yml $tool_playbook/tools.yml
sleep 10
cd $tool_playbook
ansible-playbook tools.yml -i "localhost,"
echo ""