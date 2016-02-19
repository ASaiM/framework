#!/bin/bash
. src/misc.sh

echo "Remove local galaxy dir..."
echo "=========================="
rm -rf $galaxy_dir
echo ""

echo "Remove local shed dir..."
echo "=========================="
rm -rf $shed_dir
echo ""

echo "Drop database and user..."
echo "========================="
$src_postgresql/clean_postgres_db.sh