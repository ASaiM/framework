# Galaxy - ASaiM
FROM quay.io/bgruening/galaxy:17.09

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="ASaiM" \
    GALAXY_CONFIG_CONDA_AUTO_INSTALL=True

# Change the tool_conf to get different tool sections and labels
COPY config/tool_conf.xml $GALAXY_ROOT/config/

# Install tools
# Split into multiple layers to minimize disk space usage while building
# Rules to follow:
#  - Keep in the same yaml file the tools that share common conda dependencies (conda is only able to use hardlinks within a Docker layer)
#  - Docker will use 2*(size of the layer) on the disk while building, so 1 yaml should not install more data than half of the remaining space on the disk
#     => 'big' tools should go in the first yaml file, the last yaml file should contain smaller tools
#  - When one of the layer can't be built with a "no space left" error message, you'll probably need to split a yaml in 2 (supposing you followed the previous rules)
COPY config/asaim_tools_1.yaml $GALAXY_ROOT/asaim_tools_1.yaml
COPY config/asaim_tools_2.yaml $GALAXY_ROOT/asaim_tools_2.yaml
COPY config/asaim_tools_3.yaml $GALAXY_ROOT/asaim_tools_3.yaml
COPY config/asaim_tools_4.yaml $GALAXY_ROOT/asaim_tools_4.yaml
RUN df -h && \
    install-tools $GALAXY_ROOT/asaim_tools_1.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes && \
    rm -rf /tool_deps/_conda/pkgs && \
    df -h
RUN df -h && \
    install-tools $GALAXY_ROOT/asaim_tools_2.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes && \
    rm -rf /tool_deps/_conda/pkgs && \
    df -h
RUN df -h && \
    install-tools $GALAXY_ROOT/asaim_tools_3.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes && \
    rm -rf /tool_deps/_conda/pkgs && \
    df -h
RUN df -h && \
    install-tools $GALAXY_ROOT/asaim_tools_4.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes && \
    rm -rf /tool_deps/_conda/pkgs && \
    df -h && \
    mkdir -p $GALAXY_ROOT/workflows

# Import workflows (local and from training) and data manager description, install the data libraries and the workflows
COPY config/workflows/* $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/workflows/wgs-worklow.ga $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/workflows/wgs-worklow.ga $GALAXY_ROOT/workflows/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/mothur-miseq-sop/workflows/mothur-miseq-sop.ga $GALAXY_ROOT/workflows/
COPY config/data_managers.yaml $GALAXY_ROOT/data_managers.yaml
COPY config/data_library.yaml $GALAXY_ROOT/data_library.yaml
ENV GALAXY_CONFIG_TOOL_PATH=/galaxy-central/tools/
RUN startup_lite && \
    galaxy-wait && \
    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD
#RUN startup_lite && \
#    galaxy-wait && \
#    setup-data-libraries -i $GALAXY_ROOT/data_library.yaml -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD


# Copy the script to launch the data managers
COPY bin/run_data_managers run_data_managers

# Install the tours
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/tours/metagenomics-general-tutorial-amplicon.yml $GALAXY_ROOT/config/plugins/tours/
ADD https://raw.githubusercontent.com/galaxyproject/training-material/master/topics/metagenomics/tutorials/general-tutorial/tours/metagenomics-general-tutorial-shotgun.yml $GALAXY_ROOT/config/plugins/tours/

# Add Container Style
ENV GALAXY_CONFIG_WELCOME_URL=$GALAXY_CONFIG_DIR/web/welcome.html
COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY config/asaim_logo.svg $GALAXY_CONFIG_DIR/web/welcome_asaim_logo.svg
