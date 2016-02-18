#!/bin/bash
. src/misc.sh

get_postgresql_prefix

./$src_postgresql/clean_postgres_db.sh

$command_prefix createdb $db_name
$command_prefix psql $db_name -c "SET CLIENT_ENCODING to 'UNICODE'"
$command_prefix psql $db_name -c "CREATE USER $db_role WITH PASSWORD '$db_password'"
$command_prefix psql $db_name -c "GRANT ALL PRIVILEGES ON DATABASE $db_name to $db_role"
