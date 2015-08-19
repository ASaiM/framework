ASaiM Galaxy
============

Clone galaxy code, config galaxy, add tools and launch galaxy

# Usage

For Mac User, launch before:

```
boot2docker init
boot2docker start
eval "$(boot2docker shellinit)"
```

Configure Docker for Galaxy (`${user}` corresponds to your user id on your computer)
```
sudo groupadd -f docker
sudo gpasswd -a ${user} docker
sudo service docker restart
```

Launch script:
```
./src/prepare_galaxy.sh
```



# Tool integration

To integrate a tool:

1. Create a directory in `tools`
2. Add the sources (if they are not in a remote repository)
3. Create a Dockerfile in this directory
4. Create a configuration file in this directory
5. Integrate information about this tool in `tool_conf.xml` and `prepare_galaxy_tools.sh`