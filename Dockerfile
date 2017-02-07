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
RUN mkdir /databases && \
    mkdir /databases/rRNA_databases && \
    sed -i.bak 's/#rfam/rfam/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc && \
    sed -i.bak 's/#silva/silva/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc && \
    sed -i.bak 's/SORTMERNADIR/databases/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/rnateam/sortmerna/59252ca85c74/rRNA_databases.loc && \
    mkdir /databases/db_v20 && \
    sed -i.bak 's/#mpa_v20_m200/mpa_v20_m200/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/bebatut/metaphlan2/8991e05c44e4/metaphlan2_db.loc && \
    sed -i.bak 's/METAPHLAN2_DIR/databases/' $GALAXY_ROOT/tool-data/toolshed.g2.bx.psu.edu/repos/bebatut/metaphlan2/8991e05c44e4/metaphlan2_db.loc
ADD https://github.com/biocore/sortmerna/archive/2.1b.tar.gz 2.1b.tar.gz
RUN tar xzf 2.1b.tar.gz && \
    mv sortmerna-2.1b/rRNA_databases/* /databases/rRNA_databases && \
    rm 2.1b.tar.gz && \
    rm -rf sortmerna-2.1b/ && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/rfam-5.8s-database-id98.fasta,/databases/rRNA_databases/rfam-5.8s-database-id98 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/rfam-5s-database-id98.fasta,/databases/rRNA_databases/rfam-5s-database-id98 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-arc-16s-id95.fasta,/databases/rRNA_databases/silva-arc-16s-id95 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-arc-23s-id98.fasta,/databases/rRNA_databases/silva-arc-23s-id98 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-bac-16s-id90.fasta,/databases/rRNA_databases/silva-bac-16s-id90 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-bac-23s-id98.fasta,/databases/rRNA_databases/silva-bac-23s-id98 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-euk-18s-id95.fasta,/databases/rRNA_databases/silva-euk-18s-id95 && \
    /tool_deps/_conda/envs/__sortmerna\@2.1b/bin/indexdb_rna --ref /databases/rRNA_databases/silva-euk-28s-id98.fasta,/databases/rRNA_databases/silva-euk-28s-id98
ADD https://bitbucket.org/biobakery/metaphlan2/get/2.5.0.zip 2.5.0.zip
RUN unzip 2.5.0.zip && \
    mv biobakery-metaphlan2-6f2a1673af85/db_v20/* /databases/db_v20/ && \
    rm 2.5.0.zip && \
    rm -rf biobakery-metaphlan2-6f2a1673af85
RUN /tool_deps/_conda/envs/__humann2@0.6.1/bin/humann2_databases --download chocophlan full /databases && \
    /tool_deps/_conda/envs/__humann2@0.6.1/bin/humann2_databases --download uniref diamond /databases

# Container Style
COPY data/static/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY data/images/asaim_logo.svg $GALAXY_CONFIG_DIR/web/asaim_logo.svg
RUN sed -i.bak 's/images\/asaim_logo/asaim_logo/' $GALAXY_CONFIG_DIR/web/welcome.html 