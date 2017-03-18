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

COPY data/galaxy_config/tool_conf.xml $GALAXY_ROOT/config/

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'

# Install tools
COPY data/chosen_tools/asaim_tools.yml $GALAXY_ROOT/asaim_tools.yml
RUN install-tools $GALAXY_ROOT/asaim_tools.yml && \
    /tool_deps/_conda/bin/conda clean --tarballs

# Import workflows
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_main_workflow.ga $GALAXY_ROOT/asaim_main_workflow.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomic_result_comparative_analysis.ga $GALAXY_ROOT/asaim_taxonomic_result_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_functional_result_comparative_analysis.ga $GALAXY_ROOT/asaim_functional_result_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_go_slim_terms_comparative_analysis.ga $GALAXY_ROOT/asaim_go_slim_terms_comparative_analysis.ga
ADD https://raw.githubusercontent.com/ASaiM/galaxytools/master/workflows/asaim/asaim_taxonomically_related_functional_result_comparative_analysis.ga $GALAXY_ROOT/asaim_taxonomically_related_functional_result_comparative_analysis.ga
COPY src/prepare_asaim/import_workflows.py $GALAXY_ROOT/import_workflows.py

RUN startup_lite && \
    sleep 30 && \
    . $GALAXY_VIRTUAL_ENV/bin/activate && \
    python $GALAXY_ROOT/import_workflows.py

# Add more scripts to prepare and launch Galaxy
COPY src/prepare_asaim/download_databases.sh /usr/bin/download_databases
COPY src/prepare_asaim/launch_galaxy_instance.sh /usr/bin/launch_galaxy_instance
COPY src/prepare_asaim/launch_data_managers.py /usr/bin/launch_data_managers.py
RUN chmod +x /usr/bin/download_databases
RUN chmod +x /usr/bin/launch_galaxy_instance

# Add Container Style
COPY data/static/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY data/images/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg
RUN sed -i.bak 's/images\/asaim_logo/asaim_logo/' $GALAXY_CONFIG_DIR/web/welcome.html 

# To launch during container start
CMD ["/usr/bin/launch_galaxy_instance"]