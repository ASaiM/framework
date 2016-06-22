ASaiM framework
===============

ASaiM framework is an open-source opinionated Galaxy-based framework. It integrates tools, specifically chosen for metagenomic and metatranscriptomic studies and hierarchically organized to orient user choice toward the best tool for a given task. 

Details about this framework is available on a dedicated documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

# Installation

## Get the code

Clone the repository

```
git clone https://github.com/ASaiM/framework.git
```

## Requirements

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

## Configuration

PostgreSQL is used to manage databases in Galaxy. It must be launched as a background task and setup for Galaxy (new database and user creation).

On the other hand, a FTP server with `proftpd` has to be configured and launched.

All the configuration tasks (postgresql and proftpd) can be done by running:

```
$ ./src/configure.sh
```

# Usage

## Launch ASaiM framework

The framework is based on a custom Galaxy instance with tools, workflows, databases, ...

To launch the custom Galaxy instance and populate it with dedicated tools, workflows and databases :

```
$ ./src/launch_asaim.sh
```

This task, particularly tool population, can take several hours.

However, once tool population starts, the Galaxy instance can be then browse on [http://127.0.0.1:8080/](http://127.0.0.1:8080/). And after registration with admin account (email: `asaim-admin@asaim.com`), you can follow tool installation in `Admin` -> `Manage installed tools`.

After installation of the tools, HUMAnN2 databases have to be downloaded (once). It can be done using the dedicated tool available in `STRUCTURAL AND FUNCTIONAL ANALYSIS TOOLS` -> `Analyze metabolism` -> `Download HUMAnN2 databases`. This tool have to be executed twice: once for nucleotide (ChocoPhlAn) database and once for protein (UniRef50) database.

## Stop ASaiM

The custom Galaxy instance runs as a background process. To stop it:

```
$ ./src/stop_asaim.sh
```

After, to clean Galaxy (tools, ...) and also databases:

```
$ ./src/clean_asaim.sh
```

## Add tools from ToolShed to the custom Galaxy instance

To add tools from ToolShed, you can use the web interface but you can also add reference to this tool in files in `data/chosen_tools` and then launch:

```
$ ./src/prepare_asaim/populate_galaxy.sh
```

# Documentation

Available tools and workflows in ASaiM framework are described in the documentation available at [http://asaim.readthedocs.org/](http://asaim.readthedocs.org/en/latest/framework/index.html).

Moreover, [a tutorial](http://asaim.readthedocs.org/en/latest/framework/tutorial/index.html) explains how to use ASaiM framework to analyze metagenomic sequences of microbiota to obtain taxonomic and functional assignations of sequences.

# Testing

[![Build Status](https://travis-ci.org/ASaiM/framework.svg)](https://travis-ci.org/ASaiM/framework)

Functional tests are runned via TravisCI whenever this GitHub repository is updated. See the `.travis.yml` file for more technical details.

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the LICENSE file for details.

# Citation

To cite this tool, a DOI is generated for each release using Zenodo.