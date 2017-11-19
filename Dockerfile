# Galaxy - ASaiM
#
# VERSION 0.3

FROM bgruening/galaxy-stable:17.09

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="ASaiM" \
    GALAXY_CONFIG_CONDA_AUTO_INSTALL="True"

# Change the tool_conf to get different tool sections and labels
COPY config/tool_conf.xml $GALAXY_ROOT/config/

# Install tools (split in 2 layers)
COPY config/asaim_tools_1.yaml $GALAXY_ROOT/asaim_tools_1.yaml
RUN install-tools $GALAXY_ROOT/asaim_tools_1.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_ROOT/workflows
COPY config/asaim_tools_2.yaml $GALAXY_ROOT/asaim_tools_2.yaml
RUN install-tools $GALAXY_ROOT/asaim_tools_2.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_ROOT/workflows
COPY config/asaim_tools_3.yaml $GALAXY_ROOT/asaim_tools_3.yaml
RUN install-tools $GALAXY_ROOT/asaim_tools_3.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_ROOT/workflows

# Import workflows (local and from training) and data manager description, install the data libraries and the workflows
COPY config/workflows/* $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/workflows/wgs-worklow.ga $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/workflows/wgs-worklow.ga $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/mothur-miseq-sop/workflows/mothur-miseq-sop.ga $GALAXY_ROOT/workflows/
COPY config/data_managers.yaml $GALAXY_ROOT/data_managers.yaml
COPY config/data_library.yaml $GALAXY_ROOT/data_library.yaml
RUN startup_lite && \
    sleep 30 && \
    setup-data-libraries -i $GALAXY_ROOT/data_library.yaml -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD && \
    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD

COPY bin/run_data_managers run_data_managers

# Install the tours
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/tours/metagenomics-general-tutorial-amplicon.yml $GALAXY_ROOT/config/plugins/tours/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/tours/metagenomics-general-tutorial-shotgun.yml $GALAXY_ROOT/config/plugins/tours/

# Add Container Style
COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY config/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg
