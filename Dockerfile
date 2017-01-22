# Galaxy - ASaiM
#
# VERSION       0.2

FROM bgruening/galaxy-stable

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
    GALAXY_CONFIG_CONDA_AUTO_INIT=True \
    GALAXY_CONFIG_USE_CACHED_DEPENDENCY_MANAGER=True \
    GALAXY_CONFIG_BRAND="ASaiM"

WORKDIR /galaxy-central

COPY data/galaxy_config/tool_conf.xml $GALAXY_ROOT/config/
COPY data/galaxy_config/shed_tool_conf.xml $GALAXY_ROOT/config/

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

# Install tools
COPY data/chosen_tools/manipulation_tool_list.yaml $GALAXY_ROOT/manipulation_tool_list.yaml
COPY data/chosen_tools/preprocessing_tool_list.yaml $GALAXY_ROOT/preprocessing_tool_list.yaml
COPY data/chosen_tools/stuctural_functional_analysis_tool_list.yaml $GALAXY_ROOT/stuctural_functional_analysis_tool_list.yaml
COPY data/chosen_tools/visualization_stats_tool_list.yaml $GALAXY_ROOT/visualization_stats_tool_list.yaml

RUN install-tools $GALAXY_ROOT/manipulation_tool_list.yaml && \
    install-tools $GALAXY_ROOT/preprocessing_tool_list.yaml && \
    install-tools $GALAXY_ROOT/stuctural_functional_analysis_tool_list.yaml && \
    install-tools $GALAXY_ROOT/visualization_stats_tool_list.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs

# Import workflows

# Download training data and populate the data library

# Container Style
ADD data/static/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
ADD data/images/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg