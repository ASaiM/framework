FROM bgruening/galaxy-stable

# Install required python packages
COPY ./requirements.txt /requirements.txt
#RUN pip install -r ./requirements.txt

# Copy configuration files
COPY ./config/tool_conf.xml /galaxy-central/config/

# Copy tools
COPY ./tools /galaxy-central/tools/

# Prepare tools
#COPY ./src/prepare_galaxy_tools.sh /src/
#RUN /src/prepare_galaxy_tools.sh /galaxy-central

RUN mkdir -p galaxy-central/tools/quality_control/prinseq/src && \
    curl -L -s http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz | tar -C galaxy-central/tools/quality_control/prinseq/src --strip-components=1 -xz

## metaphlan 2
RUN cd /galaxy-central/tools/non_rRNA_taxonomic_assignation/metaphlan && \
    hg clone https://bitbucket.org/biobakery/metaphlan2 

## humann 2
RUN cd /galaxy-central/tools/metabolic_analysis/humann2/ && \
    hg clone https://bitbucket.org/biobakery/humann2 && \
    cd humann2 && \
    python setup.py install && \
    humman2_config --update database_folder nucleotide /data/db/chocophlan && \
    humman2_config --update database_folder protein /data/db/uniref


# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800