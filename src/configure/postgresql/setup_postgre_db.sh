#!/bin/bash
. src/misc.sh

get_postgresql_prefix

$command_prefix createdb $db_name
$command_prefix psql $db_name -c "CREATE USER $db_role WITH PASSWORD '$db_password'"
$command_prefix psql $db_name -c "GRANT ALL PRIVILEGES ON DATABASE $db_name to $db_role"
$command_prefix psql $db_name -c "SET CLIENT_ENCODING to 'UNICODE'"

$command_prefix createdb $toolshed_db_name
$command_prefix psql $toolshed_db_name -c "GRANT ALL PRIVILEGES ON DATABASE $db_name to $db_role"
$command_prefix psql $toolshed_db_name -c "SET CLIENT_ENCODING to 'UNICODE'"