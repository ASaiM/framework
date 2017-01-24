# Galaxy - ASaiM
#
# VERSION       0.2

FROM bgruening/galaxy-stable:16.10

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
    GALAXY_CONFIG_CONDA_AUTO_INIT=True \
    GALAXY_CONFIG_USE_CACHED_DEPENDENCY_MANAGER=True \
    GALAXY_CONFIG_BRAND="ASaiM"

#WORKDIR /galaxy-central

COPY data/galaxy_config/tool_conf.xml $GALAXY_ROOT/config/

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

# Install tools
COPY data/chosen_tools/asaim_tools.yml $GALAXY_ROOT/asaim_tools.yml

RUN install-tools $GALAXY_ROOT/asaim_tools.yml

# Import workflows

# Download training data and populate the data library

# Container Style
ADD data/static/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD data/images/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg