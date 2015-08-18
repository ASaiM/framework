

FROM debian:wheezy

MAINTAINER Berenice Batut, berenice.batut@gmail.com

RUN apt-get update && apt-get install -y \
    python \
    && apt-get clean

COPY extract_similarity_search_report.py /usr/bin/extract_similarity_search_report.py
RUN chmod a+x /usr/bin/extract_similarity_search_report.py
