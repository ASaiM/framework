#!/bin/bash
. src/parse_yaml.sh
eval $(parse_yaml src/misc/config.yml "")

echo "Remove local galaxy dir..."
echo "=========================="
rm -rf $galaxy_dir
echo ""

echo "Remove local shed dir..."
echo "=========================="
rm -rf $shed_dir
echo ""

echo "Remove virtualenv..."
echo "===================="
sudo rm -rf venv
echo ""

echo "Drop database and user..."
echo "========================="
echo -e "drop database and users? (y/n)"
read 
if [ $REPLY == "y" ]; then
    ./src/postgresql/clean_postgres_db.sh
fi