#!/usr/bin/env bash
. src/misc.sh

get_postgresql_prefix

if [[ ! -z `$command_prefix psql -lqt | cut -d \| -f 1 | grep -w $db_name` ]]; then
    echo "Database $db_name exists. Do you want to drop it? (y/N)"
    read answer
    if [[ $answer == "y" || $answer == "Y" ]]; then
        echo "  Drop $db_name db"
        $command_prefix dropdb $db_name
    fi
fi

if $command_prefix psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$db_role'" | grep -q 1; then
    echo "Role $db_role exists. Do you want to drop it? (Y/n)"
    read answer
    if [[ $answer == "y" || $answer == "Y" ]]; then
        echo "  Drop $db_role role"
        $command_prefix dropuser $db_role
    fi
fi
