#!/bin/bash

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
    echo "database_connection=postgresql://galaxy:password@localhost:5432/asaim_galaxy?client_encoding=utf8" >> $1
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
    echo "debug = True" >> $1
    echo "use_interactive = True" >> $1
    echo "" >> $1
    echo "admin_users = $admin_users" >> $1
    echo "ftp_upload_dir = database/ftp/" >> $1
    echo "ftp_upload_site = ftp localhost port 21" >> $1
    echo "master_api_key = $master_api_key" >> $1
}