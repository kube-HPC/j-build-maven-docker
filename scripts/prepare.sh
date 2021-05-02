#!/bin/bash
# set -eo pipefail
set -x
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
NETWORK_NAME=artifacts-registry-network
docker stop nexus || true && docker rm nexus || true
docker network rm ${NETWORK_NAME} || true
docker network create ${NETWORK_NAME}
cp -r nexus-data-template nexus-data
chmod -R 777 nexus-data
docker run -d --network=${NETWORK_NAME} -p 8081:8081 -u $(id -u) --name nexus -v ${SCRIPTPATH}/../nexus-data/:/nexus-data   sonatype/nexus3
echo Waiting for nexus to be up
ret=$(curl -s -o /dev/null -w "%{http_code}" localhost:8081)
while [[ $ret != "200" ]]; do
  echo ret=$ret
  sleep 5
  ret=$(curl -s -o /dev/null -w "%{http_code}" localhost:8081)
  docker ps -a
done
# bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:8081)" != "200" ]]; do echo -n .; sleep 5; done; echo ""'
echo nexus is up. 
export javaWrapperVersion=${javaWrapperVersion:-'2.0-SNAPSHOT'}
envsubst < ${SCRIPTPATH}/../m2-project/pomTemplate.xml >  ${SCRIPTPATH}/../m2-project/pom.xml
docker  run --network=${NETWORK_NAME} --rm  -v ${SCRIPTPATH}/../m2-project:/m2-project -w /m2-project maven mvn --settings /m2-project/settings.xml package  
docker  run --network=${NETWORK_NAME} --rm  -v ${SCRIPTPATH}/../m2-project:/m2-project -w /m2-project maven mvn dependency:get --settings /m2-project/settings.xml  -Dartifact=io.hkube:wrapper:${javaWrapperVersion}:jar:wide 
rm -r -f ${SCRIPTPATH}/../nexus-data/javaprefs/.java


