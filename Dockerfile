FROM bgruening/galaxy-stable

EXPOSE :80
EXPOSE :21
EXPOSE :8800

COPY ./config /galaxy-central/config/
COPY ./tools /galaxy-central/tools/