#!/bin/bash

generate_tools_yml $tool_playbook/tools.yml
sleep 10
cd $tool_playbook
ansible-playbook tools.yml -i "localhost,"
echo ""