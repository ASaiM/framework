#!/bin/sh

#boot2docker start
#eval "$(boot2docker shellinit)"

#eval "$(boot2docker shellinit)"
docker build -t asaim/extract-similarity-search-report tools/extract/extract_similarity_search_report
cp tools/extract/extract_similarity_search_report/extract_similarity_search_report.xml ../galaxy/tools/docker/extract_similarity_search_report.xml

