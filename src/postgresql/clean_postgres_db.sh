#!/bin/bash
DB_NAME=asaim_galaxy
DB_ROLE=galaxy

if [[ "$OSTYPE" == "darwin"* ]]; then
    command_prefix=""
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    command_prefix="sudo -u postgres"
fi

if $command_prefix psql ${DB_NAME} -c '' 2>&1; then
    echo "database ${DB_NAME} exists"
    $command_prefix dropdb ${DB_NAME}
fi
if $command_prefix psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_ROLE}'" | grep -q 1; then 
    echo "role ${DB_ROLE} exists"
    $command_prefix dropuser ${DB_ROLE}
fi