ASaiM framework
===============

ASaiM framework is an open-source opinionated Galaxy-based framework. It integrates tools, specifically chosen for metagenomic and metatranscriptomic studies and hierarchically organized to orient user choice toward the best tool for a given task.

Details about this framework is available on a dedicated documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/).

This framework is using the [Galaxy Docker](http://bgruening.github.io/docker-galaxy-stable/) to ease the deployment the Galaxy instance. If you do not want to use Docker, we also provide [documentation to setup and run the framework](#installation-and-use-without-using-docker) without using Docker.

# Usage

## Requirements

To use the ASaiM framework, [Docker](https://www.docker.com/products/overview#h_installation) is required (except if you want to [setup and run the framework without using Docker](#installation-and-use-without-using-docker)). 

For Linux users and people familiar with the command line, please follow the [very good instructions](https://docs.docker.com/installation/) from the Docker project. Non-Linux users are encouraged to use [Kitematic](https://kitematic.com), a graphical User-Interface for managing Docker containers.

## ASaiM launch

Starting the ASaiM Docker container is analogous to starting the generic Galaxy Docker image: 

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

### ASaiM use

The previous commands will start the ASaiM framework with the configuration and launch of a Galaxy instance and its population with the needed tools, workflows and databases. The instance will be accessible at [http://localhost:8080](http://localhost:8080).

> Starting the Docker container is long process. You can inspect the state of the starting using:
> ```
> $ docker ps # to obtain the id of the container
> $ docker logs <container_id>
> ```

### Interactive session

For an interactive session, you can execute:

```
$ docker run -i -t -p 8080:80 quay.io/bebatut/asaim-framework /bin/bash
```

and manually invokes the `/usr/bin/launch_galaxy_instance` script to start PostgreSQL, Apache and Galaxy and download the need databases.

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

# Installation and use without using Docker

Sometimes Docker can not be used for some system configuration. We then provided the scripts and documentation to deploy and use ASaiM outside Docker.

## Installation

### Get the code

Clone the repository

```
git clone https://github.com/ASaiM/framework.git
```

### Requirements

Some tools must be installed:

- `git`
- `python`
- `pip`
- `perl`
- `scons`
- `mercurial`
- `openssl`
- `java`
- `wget`
- `openssl`
- `proftpd` (installed in `/usr/local`)
- `postgresql`

For Debian, RHEL and MacOSX, all dependencies can be installed by running:

```
./src/install_dependencies.sh
```

**Note:** `apt-get` is required for Debian, `yum` for RHEL and `homebrew` and `MacPorts` for MacOSX.

### Configuration

PostgreSQL is used to manage databases in Galaxy. It must be launched as a background task and setup for Galaxy (new database and user creation).

On the other hand, a FTP server with `proftpd` has to be configured and launched.

All the configuration tasks (postgresql and proftpd) can be done by running:

```
$ ./src/configure.sh
```

## Usage

### Launch ASaiM framework

The framework is based on a custom Galaxy instance with tools, workflows, databases, ...

To launch the custom Galaxy instance and populate it with dedicated tools, workflows and databases :

```
$ ./src/launch_asaim.sh
```

This task, particularly tool population, can take several hours.

However, once tool population starts, the Galaxy instance can be then browse on [http://127.0.0.1:8080/](http://127.0.0.1:8080/). And after registration with admin account (email: `asaim-admin@asaim.com`), you can follow tool installation in `Admin` -> `Manage installed tools`.

After installation of the tools, HUMAnN2 databases have to be downloaded (once). It can be done using the dedicated tool available in `STRUCTURAL AND FUNCTIONAL ANALYSIS TOOLS` -> `Analyze metabolism` -> `Download HUMAnN2 databases`. This tool have to be executed twice: once for nucleotide (ChocoPhlAn) database and once for protein (UniRef50) database.

### Add workflows

Workflows are not automatically added to the Galaxy instance. To add them:

- Go to `Workflow` menu (top panel)
- Click on `Upload or import workflows` (on top right)
    - Paste the following URL (one at a time) in "Galaxy workflow URL" field
        - Main workflow: [https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_main_workflow.ga](https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_main_workflow.ga)
        - Comparative analysis workflows:
            - For taxonomic results: [https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomic_result_comparative_analysis.ga](https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomic_result_comparative_analysis.ga)
            - For functional results (gene families or pathways): [https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_functional_result_comparative_analysis.ga](https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_functional_result_comparative_analysis.ga)
            - For GO slim terms: [https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_go_slim_terms_comparative_analysis.ga](https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_go_slim_terms_comparative_analysis.ga)
            - For taxonomically-related functional results: [https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomically_related_functional_result_comparative_analysis.ga](https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomically_related_functional_result_comparative_analysis.ga)
    - Click on `Import`
- Do it again with other workflows

### Stop ASaiM

The custom Galaxy instance runs as a background process. To stop it:

```
$ ./src/stop_asaim.sh
```

After, to clean Galaxy (tools, ...) and also databases:

```
$ ./src/clean_asaim.sh
```

### Add tools from ToolShed to the custom Galaxy instance

To add tools from ToolShed, you can use the web interface but you can also add reference to this tool in files in `data/chosen_tools` and then launch:

```
$ ./src/prepare_asaim/populate_galaxy.sh
```

# Documentation

Available tools and workflows in ASaiM framework are described in the documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

Moreover, [a tutorial](http://asaim.readthedocs.org/en/latest/framework/tutorial/index.html) explains how to use ASaiM framework to analyze metagenomic sequences of microbiota to obtain taxonomic and functional assignations of sequences.

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the [LICENSE](LICENSE) file for details.

# Citation

To cite this tool, a DOI is generated for each release using Zenodo. Check the [CITATION](CITATION) file for details.
