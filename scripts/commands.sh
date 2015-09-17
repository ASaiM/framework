#!/bin/bash


#cd Documents/Post_doc/ASaiM/galaxy_tools/
boot2docker start
eval "$(boot2docker shellinit)"
boot2docker ip

docker build -t='galaxy' .
#docker ps
#docker rm (image sur le port 80)
#docker run -i -p 8080:80 galaxy



#COPY ./config /galaxy-central/config/
#COPY ./tools /galaxy-central/tools/