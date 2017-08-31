ASaiM framework
===============

[![Docker Repository on Quay](https://quay.io/repository/bebatut/asaim-framework/status "Docker Repository on Quay")](https://quay.io/repository/bebatut/asaim-framework)

ASaiM framework is an open-source opinionated Galaxy-based framework. It integrates tools, specifically chosen for metagenomic and metatranscriptomic studies and hierarchically organized to orient user choice toward the best tool for a given task.

Details about this framework is available on a dedicated documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/).

This framework is using the [Galaxy Docker](http://bgruening.github.io/docker-galaxy-stable/) to ease the deployment the Galaxy instance.

# Usage

## Requirements

To use the ASaiM framework, [Docker](https://www.docker.com/products/overview#h_installation) is required (except if you want to [setup and run the framework without using Docker](#installation-and-use-without-using-docker)). 

For Linux users and people familiar with the command line, please follow the [very good instructions](https://docs.docker.com/installation/) from the Docker project. Non-Linux users are encouraged to use [Kitematic](https://kitematic.com), a graphical User-Interface for managing Docker containers.

## ASaiM launch

1. Starting the ASaiM Docker container: analogous to starting the generic Galaxy Docker image: 

    ```
    $ docker run -d -p 8080:80 quay.io/bebatut/asaim-framework
    ```

    Nevertheless, here is a quick rundown: 

    - `docker run` starts the Image/Container

        In case the Container is not already stored locally, Docker downloads it automatically
       
    - The argument `-p 8080:80` makes the port 80 (inside of the container) available on port 8080 on your host

        Inside the container a Apache web server is running on port 80 and that port can be bound to a local port on your host computer. 
        With this parameter you can access your Galaxy instance via `http://localhost:8080` immediately after executing the command above
        
    - `quay.io/bebatut/asaim-framework` is the Image/Container name, that directs Docker to the correct path in the [Docker index](https://index.docker.io/u/bgruening/galaxy-rna-workbench/)
    - `-d` will start the Docker container in Daemon mode. 

    > A detailed discussion of Docker's parameters is given in the [Docker manual](http://docs.docker.io/). It is really worth reading.

    The Docker container is run: Galaxy will be launched!

    > Setting up Galaxy and its components can take several minutes. You can inspect the state of the starting using:
    > ```
    > $ docker ps # to obtain the id of the container
    > $ docker logs <container_id>
    > ```

    The previous commands will start the ASaiM framework with the configuration and launch of a Galaxy instance and its population with the needed tools, workflows and databases. The instance will be accessible at [http://localhost:8080](http://localhost:8080).

2. Installation of the databases once Galaxy is running

    ```
    $ docker exec <container_id> ./run_data_managers
    ```


#### Workflows

To access to the workflows, you need to connect with the admin user (username: `admin@galaxy.org`, password: `admin`). And you will have access to the workflows in the 'Workflow' section (Top panel)

#### Databases

Databases are automatically added to the Galaxy instance for MetaPhlAn2, HUMAnN2 and QIIME.

Sometimes the databases are not correctly seen by the tools. If it is the case, you need to force the connection between the tool and the database:

- Connect with the admin user: 
    - username `admin@galaxy.org` 
    - password `admin`
- Go to the 'Admin' section (Top panel)
- Go to 'Local data' section (Left panel)
- Click on `humann2_nucleotide_database`, `humann2_protein_database` or `metaphlan2_database` (depending on the database)
- Click on the 'Reload button' on the top
    
    The table must be filled

If you want other databases for HUMAnN2 or QIIME, you can install them "manually":

- Connect with the admin user: 
    - username `admin@galaxy.org` 
    - password `admin`
- Go to the 'Admin' section (Top panel)
- Go to 'Local data' section (Left panel)
- Click on 'HUMAnN2 download' (or 'Download QIIME') and choose the database you want to import

### Interactive session

For an interactive session, you can execute:

```
$ docker run -i -t -p 8080:80 quay.io/bebatut/asaim-framework /bin/bash
```

and manually invokes the `startup` script to start PostgreSQL, Apache and Galaxy and download the need databases.

> For a more specific configuration, you can have a look at the [documentation of the Galaxy Docker Image](http://bgruening.github.io/docker-galaxy-stable/).

### Data

Docker images are "read-only". All changes during one session are lost after restart. This mode is useful to present ASaiM to your colleagues or to run workshops with it. 

To install Tool Shed repositories or to save your data, you need to export the computed data to the host computer. Fortunately, this is as easy as:

```
$ docker run -d -p 8080:80 -v /home/user/galaxy_storage/:/export/ quay.io/bebatut/asaim-framework
```

Given the additional `-v /home/user/galaxy_storage/:/export/` parameter, Docker will mount the folder `/home/user/galaxy_storage` into the Container under `/export/`. A `startup.sh` script, that is usually starting Apache, PostgreSQL and Galaxy, will recognize the export directory with one of the following outcomes:

- In case of an empty `/export/` directory, it will move the [PostgreSQL](http://www.postgresql.org/) database, the Galaxy database directory, Shed Tools and Tool Dependencies and various configure scripts to /export/ and symlink back to the original location.
- In case of a non-empty `/export/`, for example if you continue a previous session within the same folder, nothing will be moved, but the symlinks will be created.

This enables you to have different export folders for different sessions - meaning real separation of your different projects.

### Users & Passwords

The Galaxy Admin User has the username `admin@galaxy.org` and the password `admin`.

The PostgreSQL username is `galaxy`, the password `galaxy` and the database name `galaxy`.
If you want to create new users, please make sure to use the `/export/` volume. Otherwise your user will be removed after your Docker session is finished.

### Stoping ASaiM

Once you are done with the ASaiM framework, you can kill the container:

```
$ docker ps # to obtain the id of the container
$ docker kill <container_id>
```

> The image corresponding to the container will stay in memory. If you want to clean fully your Docker engine, you can follow the [Docker Cleanup Commands](https://www.calazan.com/docker-cleanup-commands/).

# Documentation

Available tools and workflows in ASaiM framework are described in the documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

Moreover, [a tutorial](https://asaim.readthedocs.io/en/latest/tutorial/index.html) explains how to use ASaiM framework to analyze metagenomic sequences of microbiota to obtain taxonomic and functional assignations of sequences.

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the [LICENSE](LICENSE) file for details.

# Citation

To cite this tool, a DOI is generated for each release using Zenodo. Check the [CITATION](CITATION) file for details.
