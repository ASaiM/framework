ASaiM framework
===============

The ASaiM framework is a Galaxy instance with a local server developed to
process data from gut microbiota.

# Get the code

Clone the repository

```
git clone https://github.com/ASaiM/framework.git
```

# If Docker is not used

## Requirements

Some tools must be installed before launching any scripts:

- `git`
- `python`
- `pip`
- `perl`
- `scons`
- `mercurial`
- `openssl` > 1.0.0c
- `java` 

Some tools are tested and installed by a custom script executed automatically 
when galaxy is launched:

- `git-hg`
- `proftpd`
- python libraries in `requirements.txt` with `pip install -r requirements.txt`

For Ubuntu

- `libssl-dev`

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

## Usage

Launch script:

```
./scripts/launch_galaxy.sh
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
./scripts/launch_galaxy.sh
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

# License

ASaiM framework is released under Apache 2 License. See the LICENSE file for details.
