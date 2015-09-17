ASaiM Galaxy
============

Clone galaxy code, config galaxy, add tools and launch galaxy

# If Docker is not used

## Requirements

### Various tools

`git`, `mercurial`, `python`, `scons`, `perl`, `openssl` > 1.0.0c

Some are tested and installed by a custom script 

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

``
postgres@dbserver:~$ createuser -SDR galaxyftp
postgres@dbserver:~$ createdb galaxydb
postgres@dbserver:~$ psql galaxydb
psql (9.4.4)
Type "help" for help.

galaxydb=# ALTER ROLE galaxyftp PASSWORD 'ftppasswd'
galaxydb-# GRANT SELECT ON galaxy_user TO galaxyftp
```

Quit `psql` and `postgres` (`CTRL+D`)

### ProFTPd

automatically installed with custom script

#### Installation

##### Ubuntu/Debian 

```
username@compute:galaxy_tool_dir$ sudo apt-get install proftpd-basic proftpd-mod-pgsql proftpd-mod-mysql
username@compute:galaxy_tool_dir$ echo 'LoadModule mod_sql.c' >> /etc/proftpd/modules.conf
username@compute:galaxy_tool_dir$ echo 'LoadModule mod_sql_passwd.c' >> /etc/proftpd/modules.conf
username@compute:galaxy_tool_dir$ echo 'LoadModule mod_sql_postgres.c' >> /etc/proftpd/modules.conf
```

##### Mac

With `brew`:

```
username@compute:galaxy_tool_dir$ brew install proftpd
```

At login:

```
username@compute:galaxy_tool_dir$ ln -sfv /usr/local/opt/proftpd/*.plist ~/Library/LaunchAgents
username@compute:galaxy_tool_dir$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.proftpd.plist
```

#### Configuration to use PBKDF2 password authentication

ProFTPd's default configuration file is located in `/etc/proftpd/proftpd.conf` 
(for Ubuntu) and in `/usr/local/etc/proftpd.conf` (for MacOSX), or otherwise in 
the etc subdirectory where ProFTPd is installed.

```
username@compute:galaxy_tool_dir$ sudo cp config/proftpd.conf /etc/proftpd/proftpd.conf
```

The configuration file in `config/proftpd.conf` is inspired from 
[Peter Briggs](https://gist.githubusercontent.com/pjbriggs/9c8db43d8ac12c686fa7/raw/3b509c7575842c9275fcc8e3d5865ddede19e155/proftpd.conf-extract)

Make ProFTPd run as a service 

```
username@compute:galaxy_tool_dir$ sudo service proftpd start
```

## Usage

Launch script:
```
./src/prepare_galaxy.sh
```
## Possible errors


# If Docker is used

## Installation

Linux

Mac: install `docker` and `boot2docker`


## Configuration

#### Linux

Configure Docker for Galaxy (`${user}` corresponds to your user id on your 
computer)
```
sudo groupadd -f docker
sudo gpasswd -a ${user} docker
sudo service docker restart
```

#### Mac

First time, configure Docker
```
sudo dscl . -create /groups/docker
sudo dscl . -append /groups/docker GroupMembership cidam
```

After turn on the computer, launch boot2docker
```
boot2docker init
```

Regularly, 
```
boot2docker start
eval "$(boot2docker shellinit)"
```

## Usage

Launch script:
```
./src/prepare_galaxy.sh
```

## Possible errors

### Address already in use

Error:
```
socket.error: [Errno 48] Address already in use
```

A processus is already bound to the default port (8000):
```
ps -fA | grep python
  501 28440 28435   0  3:58   ttys000   80:38.61 python ./scripts/paster.py serve config/galaxy.ini
  501 31145 23036   0  8:48   ttys001    0:00.00 grep python
```

The second number is the process number; stop the server by sending it a signal:
```
kill 28440
``` 

# Tool integration

To integrate a tool:

1. Create a directory in `tools`
2. Add the sources (if they are not in a remote repository)
3. Create a Dockerfile in this directory
4. Create a configuration file in this directory
5. Integrate information about this tool in `tool_conf.xml` and 
`prepare_galaxy_tools.sh`