#!/bin/bash

# Create the admin user if not already done
# Starting with 20.05 this user is only created at first startup of galaxy
# We need to create it here for Galaxy Flavors = installing from Dockerfile

if [[ ! -z $GALAXY_DEFAULT_ADMIN_USER ]]
    then
        (
        cd $GALAXY_ROOT
        . $GALAXY_VIRTUAL_ENV/bin/activate
        echo ".. Creating admin user $GALAXY_DEFAULT_ADMIN_USER with key $GALAXY_DEFAULT_ADMIN_KEY and password $GALAXY_DEFAULT_ADMIN_PASSWORD if not existing"
        python /usr/local/bin/create_galaxy_user.py --user "$GALAXY_DEFAULT_ADMIN_EMAIL" --password "$GALAXY_DEFAULT_ADMIN_PASSWORD" \
        -c "$GALAXY_CONFIG_FILE" --username "$GALAXY_DEFAULT_ADMIN_USER" --key "$GALAXY_DEFAULT_ADMIN_KEY"
        )
fi
