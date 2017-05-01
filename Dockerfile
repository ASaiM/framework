# Galaxy - ASaiM
#
# VERSION 0.2

FROM bgruening/galaxy-stable:17.01

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
    GALAXY_CONFIG_CONDA_AUTO_INIT=True \
    GALAXY_CONFIG_USE_CACHED_DEPENDENCY_MANAGER=True \
    GALAXY_CONFIG_BRAND="ASaiM" \
    ENABLE_TTS_INSTALL=True

COPY config/tool_conf.xml $GALAXY_ROOT/config/

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

# Install tools
COPY config/asaim_tools.yml $GALAXY_ROOT/asaim_tools.yml
RUN install-tools $GALAXY_ROOT/asaim_tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_HOME/workflows

# Import workflows
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_main_workflow.ga $GALAXY_ROOT/workflows/asaim_main_workflow.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomic_result_comparative_analysis.ga $GALAXY_ROOT/workflows/asaim_taxonomic_result_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_functional_result_comparative_analysis.ga $GALAXY_ROOT/workflows/asaim_functional_result_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_go_slim_terms_comparative_analysis.ga $GALAXY_ROOT/workflows/asaim_go_slim_terms_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomically_related_functional_result_comparative_analysis.ga $GALAXY_ROOT/workflows/asaim_taxonomically_related_functional_result_comparative_analysis.ga

RUN startup_lite && \
    sleep 30 && \
    pip install ephemeris -U && \
    workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD

# Add more scripts to prepare and launch Galaxy
COPY bin/download_tool_db.sh /usr/bin/download_tool_db
COPY src/launch_data_managers.py /usr/bin/launch_data_managers.py
RUN chmod +x /usr/bin/download_tool_db

# Add Container Style
COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY config/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg
RUN sed -i.bak 's/images\/asaim_logo/asaim_logo/' $GALAXY_CONFIG_DIR/web/welcome.html 
