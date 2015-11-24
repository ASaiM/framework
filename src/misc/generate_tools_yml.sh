#!/bin/bash

generate_tools_yml(){
    if [ -f $1 ]; then
        rm $1
    fi
    touch $1
    echo "- hosts: localhost" >> $1
    echo "  connection: local" >> $1
    echo "  vars:" >> $1
    echo "  roles:" >> $1
    echo "      - role: ansible-galaxy-tools" >> $1
    echo "        galaxy_tools_galaxy_instance_url: http://$host:$port/" >> $1
    echo "        galaxy_tools_api_key: $master_api_key" >> $1
    echo "        galaxy_tools_tool_list_files: [ \"files/tool_list.yaml\" ]" >> $1 
}