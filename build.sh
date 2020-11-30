#!/bin/bash
set -eo pipefail
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
docker stop archiva || true && docker rm archiva || true
docker run --name archiva --network="host" -p  8080:8080 -v /home/golanha/dev/hkube/maven.git/archiva-data/:/archiva-data xetusoss/archiva &
sleep 20
export javaWrapperVersion='2.0-SNAPSHOT'
envsubst < ${SCRIPTPATH}/m2-project/pomTemplate.xml >  ${SCRIPTPATH}/m2-project/pom.xml
docker  run --network="host" --rm  -v $SCRIPTPATH/m2-project:/m2-project -w /m2-project maven mvn --settings /m2-project/settings.xml package  
export VERSION=v${npm_package_version}
docker build -f ./Dockerfile -t hkube/maven-registry:${VERSION} .
docker push  hkube/maven-registry:${VERSION}

