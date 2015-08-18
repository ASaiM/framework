Integration of ASaiM tools into Galaxy and Docker
=================================================

# Use

galaxy directory must be in `../galaxy`

To build Docker images and copy the configuration files:
```
./prepare_galaxy_tools.sh
```

For Mac User, before launching `prepare_galaxy_tools.sh`, launch:

```
boot2docker init
boot2docker start
eval "$(boot2docker shellinit)"
``

# Tool integration

To integrate a tool:

1. Create a directory in `tools 
2. Add the sources
3. Create a Dockerfile in this directory
4. Create a configuration file in this directory
5. Integrate information about this tool in `tool_conf.xml` and `prepare_galaxy_tools.sh