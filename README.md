ASaiM framework
===============

# Introduction

The ASaiM framework is a Galaxy instance with a local server developed to
process data from gut microbiota.

# Folder structure

Within the `src` folder, are scripts to configure and launch a Galaxy instance.
The corresponding configuration files are in `config` folder and the local tools
in `lib` directory.

Within `data` are folders with data:

- `tool-data` for Galaxy tools
- `workflows` with predefined workflows
- `db` with one folder for each database (data and configuration file)
- `demo` with toy datasets

Each folder contains a README file.

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

After installation, python dependencies have to be installed in a virtual environment
with pip:

```
pip install --upgrade pip
pip install virtualenv
virtualenv --no-site-packages venv
source venv/bin/activate
(venv) pip install -r requirements.txt
```

For Debian, RHEL and MacOSX, all dependencies can be installed by running:

```
./src/install_dependencies.sh
```

**Note:** `apt-get` is required for Debian, `yum` for RHEL and `homebrew` and `MacPorts` for MacOSX.

## Configuration

PostgreSQL is used to manage databases in Galaxy. It must be launched as a background 
tasks. PostgreSQL database must be then setup for Galaxy (new database and user creation).
Launch and setup of PostgreSQL is done by running:

```
./src/postgresql/configure_postgres.sh
```

The FTP server with `proftpd` has to be configured and launched, by running:

```
./src/proftpd/configure_proftpd.sh
```

All the configuration (postgresql and proftpd) can be done by running:

```
./src/configure.sh
```

# Usage

## Launch Galaxy

To launch the Galaxy instance :

```
./src/launch_galaxy.sh
```

This script configure the Galaxy instance, populate it with tools, ... Check the 
[documentation](http://asaim.readthedocs.org/en/latest/framework/use.html) for more 
information about the configuration. The tool population is a long task.

The Galaxy instance can be then browse on [http://127.0.0.1:8080/](http://127.0.0.1:8080/).
After registration with admin account (email: `asaim-admin@asaim.com`), you can 
follow the tool installation in Admin -> Manage installed tools.

## Stop Galaxy

Galaxy will run in background. To stop it:

```
./src/stop_galaxy.sh
```

To clean the virtual environment and Galaxy:

```
./src/clean_galaxy.sh
```

## Add tools from ToolShed to Galaxy

To add tools from ToolShed, you can use the web interface but you can also add the
reference in one file in `lib/galaxy_tools_playbook/files/` and then launch:

```
./src/populate_galaxy.sh
```

# Tutorial

# Testing

The framework can be tested by running `src/run_tests.sh`. This script configure
 the Galaxy instance, launch Galaxy's `run_tests.sh` and then test the workflow 
in `data/demo/metatranscriptomic_data` with the corresponding input files. 

In addition the same functional tests are runned via TravisCI whenever this 
GitHub repository is updated:

[![Build Status](https://travis-ci.org/ASaiM/framework.svg)](https://travis-ci.org/ASaiM/framework)

See the `.travis.yml` file for more technical details.

# Bug Reports

Any bug can be filed in an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the LICENSE file for details.
