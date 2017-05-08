#!/bin/bash
echo "Creating the Docker registry with name $REGISTRY_NAME"
docker-machine create -d amazonec2 --amazonec2-vpc-id $VPC --amazonec2-region $REGION --amazonec2-zone $ZONE --amazonec2-instance-type t2.micro --amazonec2-subnet-id $SUBNET --amazonec2-security-group $SECURITY_GROUP $REGISTRY_NAME
