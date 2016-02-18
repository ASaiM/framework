#!/bin/bash
. src/misc.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
    command_prefix=""
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    command_prefix="sudo -u postgres"
fi

if [[ ! -z `psql -lqt | cut -d \| -f 1 | grep -w $db_name` ]]; then
    echo "Database $db_name exists. Do you want to drop it? (y/N)"
    read answer
    if (( $answer == "y" )) || (( $answer == "Y" )); then
        echo "  Drop $db_name"
        $command_prefix dropdb $db_name
    fi
fi

if [[ ! -z `psql -lqt | cut -d \| -f 1 | grep -w $toolshed_db_name` ]]; then
    echo "Database $toolshed_db_name exists. Do you want to drop it? (y/N)"
    read answer
    if (( $answer == "y" )) || (( $answer == "Y" )); then
        echo "  Drop $toolshed_db_name"
        $command_prefix dropdb $toolshed_db_name
    fi
fi

if $command_prefix psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$db_role'" | grep -q 1; then 
    echo "Role $db_role exists. Do you want to drop it? (Y/n)"
    read answer
    if (( $answer == "y" )) || (( $answer == "Y" )); then
        echo "  Drop $db_role"
        $command_prefix dropuser $db_role
    fi
fi