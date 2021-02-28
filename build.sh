#!/bin/bash
set -eo pipefail
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
docker stop nexus || true && docker rm nexus || true
chmod -R 777 ${SCRIPTPATH}/nexus-data || true
docker run -d --rm -p 8081:8081 --name nexus -v ${SCRIPTPATH}/nexus-data/:/nexus-data   sonatype/nexus3
sleep 50
export javaWrapperVersion='1.3.06'
envsubst < ${SCRIPTPATH}/m2-project/pomTemplate.xml >  ${SCRIPTPATH}/m2-project/pom.xml
docker  run --network="host" --rm  -v $SCRIPTPATH/m2-project:/m2-project -w /m2-project maven mvn --settings /m2-project/settings.xml package  
docker  run --network="host" --rm  -v $SCRIPTPATH/m2-project:/m2-project -w /m2-project maven mvn dependency:get --settings /m2-project/settings.xml  -Dartifact=io.hkube:wrapper:${javaWrapperVersion}:jar:wide 
sudo rm -r -f ${SCRIPTPATH}/nexus-data/javaprefs/.java
export VERSION=v${npm_package_version}
docker build -f ./Dockerfile -t hkube/artifacts-registry:${VERSION} .
docker push  hkube/artifacts-registry:${VERSION}

