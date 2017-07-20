#!/bin/bash
echo "Creating the Docker registry with name $REGISTRY_NAME"
docker-machine create -d linode --linode-api-key=$LINODE_TOKEN --linode-root-pass=$LINODE_PASSWORD $REGISTRY_NAME
