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

> The databases used by HUMAnN2 are quite big, we recommend to have at least 100 Gb of disk space

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

## Usage: workflows, databases, data, etc.

More details about the installation of ASaiM and its usage can be found on the [online documentation](http://asaim.readthedocs.io/en/latest/installation.html)

# Documentation

Available tools and workflows in ASaiM framework are described in the documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

Moreover, [a tutorial](https://asaim.readthedocs.io/en/latest/tutorial/index.html) explains how to use ASaiM framework to analyze metagenomic sequences of microbiota to obtain taxonomic and functional assignations of sequences.

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the [LICENSE](LICENSE) file for details.

# Citation

To cite this tool, a DOI is generated for each release using Zenodo. Check the [CITATION](CITATION) file for details.
