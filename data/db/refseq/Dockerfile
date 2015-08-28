FROM debian:8.1

RUN apt-get update && apt-get install -y \
    curl \
    python \
    && apt-get clean

COPY ./src /src

RUN mkdir /refseq

RUN python /src/RefSeq_database_download.py

CMD [ "/bin/bash" ]