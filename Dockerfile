from sonatype/nexus3
USER nexus:nexus
COPY  --chown=nexus:nexus  ./nexus-data/ /nexus-data/