#!/bin/bash

echo "Remove virtualenv..."
echo "===================="
rm -rf venv
echo ""

echo "Drop database and user..."
echo "========================="
./src/postgresql/clean_postgres_db.sh