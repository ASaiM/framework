#!/bin/bash
. src/misc/parse_yaml.sh
. src/misc/generate_tools_yml.sh

eval $(parse_yaml src/misc/config.yml "")

generate_tools_yml $tool_playbook_dir/tools.yml

echo "Wait until http://$host:$port is up"
until $(curl --output /dev/null --silent --head --fail http://$host:$port); do
    printf '.'
    sleep 1
done

cd $tool_playbook_dir
ansible-playbook tools.yml -i "localhost,"
echo ""