#!/bin/bash
. src/misc/parse_yaml.sh

eval $(parse_yaml src/misc/config.yml "")

cd $galaxy_dir
./run_tool_shed.sh