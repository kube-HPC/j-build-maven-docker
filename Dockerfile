from sonatype/nexus
USER nexus:nexus
COPY  --chown=nexus:nexus  ./sonatype-work/ /sonatype-work/