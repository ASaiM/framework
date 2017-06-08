# Galaxy - ASaiM
#
# VERSION 0.2

FROM bgruening/galaxy-stable:17.05

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="ASaiM"

# Change the tool_conf to get different tool sections and labels
COPY config/tool_conf.xml $GALAXY_ROOT/config/

# Install tools
COPY config/asaim_tools.yaml $GALAXY_ROOT/asaim_tools.yaml
RUN install-tools $GALAXY_ROOT/asaim_tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_ROOT/workflows

# Import workflows, install the tool databases and start the data managers
COPY config/workflows/* $GALAXY_ROOT/workflows/
COPY config/data_managers.yaml $GALAXY_ROOT/data_managers.yaml
RUN startup_lite && \
    sleep 30 && \
    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD
COPY bin/run_data_managers run_data_managers
    
# Add Container Style
COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY config/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg

