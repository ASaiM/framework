#!/bin/bash

echo "Remove virtualenv..."
rm -rf venv

echo "Drop database and user..."
if psql ${DB_NAME} -c '' 2>&1; then
    echo "database ${DB_NAME} exists"
    dropdb ${DB_NAME}
fi
if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_ROLE}'" | grep -q 1; then 
    echo "role ${DB_ROLE} exists"
    dropuser ${DB_ROLE}
fi