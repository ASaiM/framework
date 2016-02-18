#!/bin/bash

# From https://gist.github.com/pkuczynski/8665367
parse_yaml() {
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

generate_tools_yml(){
    if [ -f $1 ]; then
        rm $1
    fi
    touch $1
    echo "- hosts: localhost" >> $1
    echo "  connection: local" >> $1
    echo "  roles:" >> $1
    echo "      - role: ansible-galaxy-tools" >> $1
    echo "        galaxy_tools_galaxy_instance_url: http://$host:$port/" >> $1
    echo "        galaxy_tools_api_key: $master_api_key" >> $1
    echo "        galaxy_tools_tool_list_files: [ \"files/common_tool_list.yaml\", \"files/pretreatments_tool_list.yaml\", \"files/taxonomic_assignation_tool_list.yaml\", \"files/functional_assignation_tool_list.yaml\", \"files/posttreatments_tool_list.yaml\"]" >> $1 
    echo "        galaxy_server_dir: $PWD/$galaxy_dir/" >> $1
}

generate_galaxy_ini() {
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
    echo "database_connection = postgres://$db_role:$db_password@$host:5432/$db_name" >> $1
    echo "file_path = database/files" >> $1
    echo "new_file_path = database/tmp" >> $1
    echo "tool_config_file = config/tool_conf.xml,config/shed_tool_conf.xml" >> $1
    echo "tool_dependency_dir = dependency_dir" >> $1
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
    echo "debug = False" >> $1
    echo "use_interactive = False" >> $1
    echo "" >> $1
    echo "admin_users = $admin_users" >> $1
    echo "ftp_upload_dir = database/ftp/" >> $1
    echo "ftp_upload_site = ftp $host port 21" >> $1
    echo "master_api_key = $master_api_key" >> $1
}

generate_toolshed_ini() {
    if [ -f $1 ]; then
        rm $1
    fi
    touch $1
    echo "[server:main]" >> $1
    echo "use = egg:Paste#http" >> $1
    echo "port = 9009" >> $1
    echo "host = $host" >> $1
    echo "use_threadpool = True" >> $1
    echo "threadpool_workers = 10" >> $1
    echo "threadpool_kill_thread_limit = 10800" >> $1
    echo "" >> $1
    echo "[app:main]" >> $1
    echo "paste.app_factory = galaxy.webapps.tool_shed.buildapp:app_factory" >> $1
    echo "log_level = DEBUG" >> $1
    echo "database_connection = postgres://$db_role:$db_password@$host:5432/$toolshed_db_name" >> $1

    echo "new_file_path = database/tmp" >> $1
    echo "se_beaker_session = True" >> $1
    echo "session_type = memory" >> $1
    echo "session_data_dir = %(here)s/database/beaker_sessions" >> $1
    echo "session_key = galaxysessions" >> $1
    echo "session_secret = changethisinproduction" >> $1
    echo "id_secret = changethisinproductiontoo" >> $1
    echo "debug = true" >> $1
    echo "use_lint = false" >> $1
    echo "admin_users = $admin_users" >> $1
    echo "require_login = False" >> $1
    echo "sendmail_path = /usr/sbin/sendmail" >> $1
}


install_galaxy() {

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

get_postgresql_prefix() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        command_prefix=""
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        command_prefix="sudo -u postgres"
    fi
}