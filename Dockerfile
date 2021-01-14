from sonatype/nexus3
USER nexus:nexus
ENV NEXUS_DATA_RO /nexus-data-ro
COPY  --chown=nexus:nexus  ./nexus-data/ ${NEXUS_DATA_RO}/
COPY run.sh /
CMD ["sh", "-c", "/run.sh"]