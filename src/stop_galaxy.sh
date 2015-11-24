#!/bin/bash
. src/parse_yaml.sh
eval $(parse_yaml src/config.yml "")

sh $galaxy_dir/run.sh --stop-daemon