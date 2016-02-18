#!/bin/bash
. src/misc.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
    command_prefix=""
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    command_prefix="sudo -u postgres"
fi

if $command_prefix psql $db_name -c '' 2>&1; then
    echo "database $db_name exists"
    $command_prefix dropdb $db_name
fi
if $command_prefix psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$db_role'" | grep -q 1; then 
    echo "role $db_role exists"
    $command_prefix dropuser $db_role
fi