#!/usr/bin/env bash

function install_mac_dependency {
    dependency=$1
    if brew ls --versions $dependency | grep -q 1; then
        brew install $dependency
        brew link --overwrite $dependency
    fi
}

# From https://gist.github.com/pkuczynski/8665367
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(parse_yaml data/config.yml "")

function generate_tools_yml {
    if [ -f $1 ]; then
        rm $1
    fi
    touch $1
    echo "- hosts: localhost" >> $1
    echo "  gather_facts: False" >> $1
    echo "  connection: local" >> $1
    echo "  vars:" >> $1
    echo "      galaxy_tools_galaxy_instance_url: http://$host:$port/" >> $1
    echo "      galaxy_tools_api_key: $master_api_key" >> $1
    echo "      galaxy_tools_tool_list_files: [ \"files/manipulation_tool_list.yaml\", \"files/preprocessing_tool_list.yaml\", \"files/stuctural_functional_analysis_tool_list.yaml\", \"files/visualization_stats_tool_list.yaml\"]" >> $1
    echo "      galaxy_server_dir: $PWD/$galaxy_dir/" >> $1
    echo "      galaxy_tools_workflows: [ \"files/asaim_main_workflow.ga\"]" >> $1
    echo "  roles:" >> $1
    echo "      - ansible-galaxy-tools" >> $1
}

function generate_galaxy_ini {
    if [ -f $1 ]; then
        rm $1
    fi
    touch $1
    echo "[server:main]" >> $1
    echo "use = egg:Paste#http" >> $1
    echo "port = $port" >> $1
    echo "host = $host" >> $1
    echo "use_threadpool = True" >> $1
    echo "threadpool_workers = 10" >> $1
    echo "threadpool_kill_thread_limit = 10800" >> $1
    echo "" >> $1
    echo "[filter:gzip]" >> $1
    echo "use = egg:Paste#gzip" >> $1
    echo "" >> $1
    echo "[filter:proxy-prefix]" >> $1
    echo "use = egg:PasteDeploy#prefix" >> $1
    echo "prefix = /galaxy" >> $1
    echo "" >> $1
    echo "[app:main]" >> $1
    echo "use_pbkdf2 = False" >> $1
    echo "paste.app_factory = galaxy.web.buildapp:app_factory" >> $1
    echo "database_connection = postgres://$db_role:$db_password@$host:5432/$db_name?client_encoding=utf8" >> $1
    echo "file_path = database/files" >> $1
    echo "new_file_path = database/tmp" >> $1
    echo "tool_config_file = config/tool_conf.xml,config/shed_tool_conf.xml" >> $1
    echo "tool_dependency_dir = dependency_dir" >> $1
    echo "conda_prefix = dependency_dir/_conda" >> $1
    echo "conda_ensure_channels = r,bioconda,iuc" >> $1
    echo "conda_auto_install = True" >> $1
    echo "conda_auto_init = True" >> $1
    echo "tool_sheds_config_file = config/tool_sheds_conf.xml" >> $1
    echo "tool_data_table_config_path = config/tool_data_table_conf.xml" >> $1
    echo "shed_tool_data_table_config = config/shed_tool_data_table_conf.xml" >> $1
    echo "tool_data_path = tool-data" >> $1
    echo "shed_tool_data_path = tool-data" >> $1
    echo "sanitize_all_html = False" >> $1
    echo "" >> $1
    echo "use_nglims = False" >> $1
    echo "nglims_config_file = tool-data/nglims.yaml" >> $1
    echo "" >> $1
    echo "debug = True" >> $1
    echo "use_interactive = False" >> $1
    echo "" >> $1
    echo "admin_users = $admin_users" >> $1
    echo "allow_user_dataset_purge = True" >> $1
    echo "ftp_upload_dir = database/ftp/" >> $1
    echo "ftp_upload_site = $host port 21" >> $1
    echo "master_api_key = $master_api_key" >> $1
}

function install_galaxy {
    wget "https://github.com/galaxyproject/galaxy/archive/v"$galaxy_release".tar.gz"
    tar -zxf "v"$galaxy_release".tar.gz"

    if [[ $2 == "toolshed" ]]; then
        mv "galaxy-"$galaxy_release $local_toolshed_dir
    else
        mv "galaxy-"$galaxy_release $local_galaxy_dir
    fi

    rm "v"$galaxy_release".tar.gz"
    #if [[ $2 == "toolshed" ]]; then

        # --transform 's/'$local_galaxy_dir'/'$local_toolshed_dir'/' | tail
    #rm v15.10.1.tar.gz
    #else
    #    if [[ $galaxy_branch == "dev" ]]; then
    #        git clone https://github.com/galaxyproject/galaxy.git $1
    #    else
    #        wget https://codeload.github.com/galaxyproject/galaxy/tar.gz/$galaxy_branch
    #
    #        if [[ $2 == "toolshed" ]]; then
    #            tar -zxvf master --transform 's/'$local_galaxy_dir'/'$local_toolshed_dir'/' | tail
    #        else
    #            tar -zxvf $galaxy_branch | tail
    #        fi
#
    #        rm $galaxy_branch
    #    fi
    #fi
}

function get_postgresql_prefix {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        command_prefix=""
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        command_prefix="sudo -u postgres"
    fi
}

function wait_until_up {
    echo "===================================="
    echo "Wait until http://$host:$1 is up"
    echo "------------------------------------"
    echo "Warning: if more than 10 lines of points are written, there may be an issue with Galaxy."
    echo "You can check $2 file to get more information about these errors"
    echo ""
    until $(curl --output /dev/null --silent --head --fail http://$host:$1); do
        printf '.'
        sleep 1
    done
    echo ""
    echo ""
}

function launch_virtual_env {
    echo "Install virtualenv and dependencies with pip..."
    echo "==============================================="
    pip install --upgrade pip
    pip install virtualenv
    if [ ! -d .venv ]; then
        virtualenv --no-site-packages .venv
    fi
    source .venv/bin/activate
    #sudo pip install -r requirements.txt
    #echo ""
}

function uncomment_last_lines {
    input_file=$1
    output_file=$2
    tail_line_nb=$3
    lines=`wc -l < $input_file`
    head_lines=`expr $lines - $tail_line_nb`
    head -n $head_lines $input_file > $output_file
    tail -n $tail_line_nb $input_file | sed 's/^#\{1\}//' >> $output_file
}
