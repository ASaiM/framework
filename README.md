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

Some tools must be installed before launching any scripts:

- `git`
- `python`
- `pip`
- `virtualenv`: `pip install --user virtualenv`
- `perl`
- `scons`
- `mercurial`
- `openssl` > 1.0.0c
- `java` 
- `wget`

Some tools are tested and installed by a custom script executed automatically 
when galaxy is launched:

- `git-hg`
- `proftpd`
- python libraries in `requirements.txt` with `pip install -r requirements.txt`

For Ubuntu

- `libssl-dev`

## Configuration

### PostgreSQL

#### Installation

Ubuntu/Debian 

```
username@compute:galaxy_tool_dir$ sudo apt-get install postgresql-9.4
username@compute:galaxy_tool_dir$ sudo su - postgres
```

[Installation](http://www.postgresql.org/download/macosx/) for Mac OS X, with Homebrew:

```
username@compute:galaxy_tool_dir$ brew install postgresql
username@compute:galaxy_tool_dir$ mkdir -p ~/Library/LaunchAgents
username@compute:galaxy_tool_dir$ ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
username@compute:galaxy_tool_dir$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

#### Configuration for FTP file upload

```
postgres@dbserver:~$ createuser -SDR galaxyftp
postgres@dbserver:~$ createdb galaxydb
postgres@dbserver:~$ psql galaxydb
psql (9.4.4)
Type "help" for help.

galaxydb=# ALTER ROLE galaxyftp PASSWORD 'ftppasswd'
galaxydb-# GRANT SELECT ON galaxy_user TO galaxyftp
```

Quit `psql` and `postgres` (`CTRL+D`)

Make ProFTPd run as a service 

```
username@compute:galaxy_tool_dir$ sudo service proftpd start
```

# Usage

Launch script:

```
virtualenv --no-site-packages venv
source venv/bin/activate 
(venv)./scripts/launch_galaxy.sh
```

# Demo

Toy dataset?

# Testing

The framework can be tested by running `src/run_tests.sh`. This script configure
 the Galaxy instance, launch Galaxy's `run_tests.sh` and then test the workflow 
in `data/demo/metatranscriptomic_data` with the corresponding input files. 

In addition the same functional tests are runned via TravisCI whenever this 
GitHub repository is updated:

[![Build Status](https://travis-ci.org/ASaiM/galaxytools.svg)](https://travis-ci.org/ASaiM/galaxytools)

See the `.travis.yml` file for more technical details.

# Bugs

You can file an issue [here](https://github.com/ASaiM/framework/issues).

# License

ASaiM framework is released under Apache 2 License. See the LICENSE file for details.
