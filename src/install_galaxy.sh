#!/bin/bash

. src/misc/parse_yaml.sh

eval $(parse_yaml src/misc/config.yml "")

function install_galaxy {
    if [[ $galaxy_branch == "dev" ]]; then
        git clone https://github.com/galaxyproject/galaxy.git $1
    else
        wget https://codeload.github.com/galaxyproject/galaxy/tar.gz/$galaxy_branch
        
        if [[ $2 == "toolshed" ]]; then
            tar -zxvf master --transform 's/'$local_galaxy_dir'/'$local_toolshed_dir'/' | tail
        else    
            tar -zxvf $galaxy_branch | tail
        fi

        rm $galaxy_branch
    fi
}