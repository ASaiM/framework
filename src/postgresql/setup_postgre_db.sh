#!/bin/bash
DB_NAME=asaim_galaxy
DB_ROLE=galaxy

if [[ "$OSTYPE" == "darwin"* ]]; then
    command_prefix=""
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    command_prefix="sudo -u postgres"
fi

./src/postgresql/clean_postgres_db.sh

$command_prefix createdb ${DB_NAME}
$command_prefix psql ${DB_NAME} -c "CREATE USER galaxy WITH PASSWORD 'password'"
$command_prefix psql ${DB_NAME} -c "GRANT ALL PRIVILEGES ON DATABASE asaim_galaxy to galaxy"
