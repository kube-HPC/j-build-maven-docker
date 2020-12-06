#!/bin/bash
set -eo pipefail
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
docker stop nexus || true && docker rm nexus || true
docker run -d --rm -p 8081:8081 --name nexus -v ${SCRIPTPATH}/nexus-data/:/nexus-data   sonatype/nexus3
sleep 40
export javaWrapperVersion='2.0-SNAPSHOT'
envsubst < ${SCRIPTPATH}/m2-project/pomTemplate.xml >  ${SCRIPTPATH}/m2-project/pom.xml
docker  run --network="host" --rm  -v $SCRIPTPATH/m2-project:/m2-project -w /m2-project maven mvn --settings /m2-project/settings.xml package  
sudo rm -r -f ${SCRIPTPATH}/sonatype-work/.java
export VERSION=v${npm_package_version}
docker build -f ./Dockerfile -t hkube/maven-registry:${VERSION} .
docker push  hkube/maven-registry:${VERSION}

