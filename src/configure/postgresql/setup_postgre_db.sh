#!/bin/bash
. src/misc.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
    command_prefix=""
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    command_prefix="sudo -u postgres"
fi

./$src_postgresql/clean_postgres_db.sh

$command_prefix createdb $db_name
$command_prefix psql $db_name -c "CREATE USER $db_role WITH PASSWORD '$db_password'"
$command_prefix psql $db_name -c "GRANT ALL PRIVILEGES ON DATABASE $db_name to $db_role"
