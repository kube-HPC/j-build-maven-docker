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
export revision=`cat  $SCRIPTPATH/../java-wrapper-version.txt`
envsubst < ${SCRIPTPATH}/../m2-project/algorithm/pomTemplate.xml >  ${SCRIPTPATH}/../m2-project/algorithm/pom.xml
docker  run --network=${NETWORK_NAME} --rm  -v ${SCRIPTPATH}/../m2-project:/m2-project -w /m2-project/algorithm maven mvn --settings /m2-project/settings.xml package  
docker  run --network=${NETWORK_NAME} --rm  -v ${SCRIPTPATH}/../m2-project:/m2-project -w /m2-project/wrapper-download maven mvn -Drevision=${revision} --settings /m2-project/settings.xml package
echo hkube-python-wrapper==`cat $SCRIPTPATH/../python-wrapper-version.txt`>$SCRIPTPATH/requirements.txt
versions="python:2.7 python:3.5 python:3.6 python:3.7"
for v in $versions
do
  echo downloading for $v
  docker run --network=${NETWORK_NAME} --rm -v $SCRIPTPATH:/workdir  $v pip  install --trusted-host nexus --index-url http://nexus:8081/repository/python/simple -r  /workdir/requirements.txt
done



rm -r -f ${SCRIPTPATH}/../nexus-data/javaprefs/.java


