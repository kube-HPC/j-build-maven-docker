NETWORK_NAME=artifacts-registry-network
docker stop nexus || true && docker rm nexus || true
docker network rm ${NETWORK_NAME} || true