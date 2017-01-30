# Galaxy - ASaiM
#
# VERSION       0.2

FROM bgruening/galaxy-stable:16.10

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

# Preparing the databases for the tools
RUN mkdir $GALAXY_ROOT/databases && \
    mkdir $GALAXY_ROOT/databases/rRNA_databases && \
    sed -i.bak 's/#rfam/rfam/' $GALAXY_ROOT/tool-data/rRNA_databases.loc.sample && \
    sed -i.bak 's/#silva/silva/' $GALAXY_ROOT/tool-data/rRNA_databases.loc.sample && \
    sed -i.bak 's/SORTMERNADIR/GALAXY_ROOT\/databases/' $GALAXY_ROOT/tool-data/rRNA_databases.loc.sample && \
    mkdir $GALAXY_ROOT/databases/db_v20 && \
    sed -i.bak 's/#mpa_v20_m200/mpa_v20_m200/' $GALAXY_ROOT/tool-data/metaphlan2_db.loc.sample && \
    sed -i.bak 's/METAPHLAN2_DIR/GALAXY_ROOT\/databases/' $GALAXY_ROOT/tool-data/metaphlan2_db.loc.sample
ADD https://github.com/biocore/sortmerna/archive/2.1b.tar.gz
RUN mv sortmerna-2.1b/rRNA_databases/* $GALAXY_ROOT/databases/rRNA_databases && \
    rm 2.1b.tar.gz && \
    rm -rf sortmerna-2.1b/
ADD https://bitbucket.org/biobakery/metaphlan2/get/2.5.0.zip
RUN mv biobakery-metaphlan2-6f2a1673af85/db_v20/* $GALAXY_ROOT/databases/ && \
    rm 2.5.0.zip && \
    rm -rf biobakery-metaphlan2-6f2a1673af85 && \

# Container Style
COPY data/static/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY data/images/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg