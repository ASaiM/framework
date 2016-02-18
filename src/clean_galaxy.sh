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

#echo "Remove virtualenv..."
#echo "===================="
#sudo rm -rf venv
#if [[ -d /private/tmp/venv/ ]]; then
#    rm -rf /private/tmp/venv/
#fi
#echo ""

echo "Drop database and user..."
echo "========================="
echo -e "drop database and users? (y/n)"
read 
if [ $REPLY == "y" ]; then
    $src_postgresql/clean_postgres_db.sh
fi