#!/bin/bash
echo "Creating the swarm manager with name $MANAGER_NAME"
# docker-machine create -d amazonec2 --amazonec2-vpc-id $VPC --amazonec2-region $REGION --amazonec2-zone $ZONE --amazonec2-instance-type t2.micro --amazonec2-subnet-id $SUBNET --amazonec2-security-group $SECURITY_GROUP $MANAGER_NAME
for ((i=1; i<=$NUM_WORKERS; i++))
do
echo "Creating node $i with name ${SWARM_WORKERS_PREFIX}${i}"
docker-machine create -d amazonec2 --amazonec2-vpc-id $VPC --amazonec2-region $REGION --amazonec2-zone $ZONE --amazonec2-instance-type t2.micro --amazonec2-subnet-id $SUBNET --amazonec2-security-group $SECURITY_GROUP ${SWARM_WORKERS_PREFIX}${i}
done
