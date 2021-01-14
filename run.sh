#!/bin/bash
set -eo pipefail
cp -r ${NEXUS_DATA_RO}/* ${NEXUS_DATA}
${SONATYPE_DIR}/start-nexus-repository-manager.sh