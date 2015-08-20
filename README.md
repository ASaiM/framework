ASaiM Galaxy
============

Clone galaxy code, config galaxy, add tools and launch galaxy

# Requirements

## Linux

Configure Docker for Galaxy (`${user}` corresponds to your user id on your computer)
```
sudo groupadd -f docker
sudo gpasswd -a ${user} docker
sudo service docker restart
```

# Mac

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

# Usage

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
5. Integrate information about this tool in `tool_conf.xml` and `prepare_galaxy_tools.sh`