#!/bin/bash
echo "Creating the swarm manager with name $MANAGER_NAME"
docker-machine create -d linode --linode-api-key=$LINODE_TOKEN --linode-root-pass=$LINODE_PASSWORD $MANAGER_NAME
for ((i=1; i<=$NUM_WORKERS; i++))
do
echo "Creating node $i with name ${SWARM_WORKERS_PREFIX}${i}"
docker-machine create -d linode --linode-api-key=$LINODE_TOKEN --linode-root-pass=$LINODE_PASSWORD ${SWARM_WORKERS_PREFIX}${i}
done
