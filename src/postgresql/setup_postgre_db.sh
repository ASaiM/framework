#!/bin/bash

DB_NAME=asaim_galaxy
DB_ROLE=galaxy
if psql ${DB_NAME} -c '' 2>&1; then
    echo "database ${DB_NAME} exists"
    dropdb ${DB_NAME}
fi
if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_ROLE}'" | grep -q 1; then 
    echo "role ${DB_ROLE} exists"
    dropuser ${DB_ROLE}
fi

createdb ${DB_NAME}
psql ${DB_NAME} -c "CREATE USER galaxy WITH PASSWORD 'password'"
psql ${DB_NAME} -c "GRANT ALL PRIVILEGES ON DATABASE asaim_galaxy to galaxy"