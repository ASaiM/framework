#!/bin/bash
. src/misc/parse_yaml.sh
eval $(parse_yaml src/misc/config.yml "")

sh $galaxy_dir/run.sh --stop-daemon