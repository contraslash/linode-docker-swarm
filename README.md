# Provisionate a aws cluster

> Based on [this gist](https://gist.github.com/ghoranyi/f2970d6ab2408a8a37dbe8d42af4f0a5)

First edit the envvars.sh with the proper configuration.

If you don't have a configuration, create a new VPC at [AWS VPC](https://us-west-2.console.aws.amazon.com/vpc/home), following the [docker official instructions for aws](https://docs.docker.com/docker-for-aws/faqs/#recommended-vpc-and-subnet-setup)

Then load the env vars
```
source envvars.sh
```

Then execute the creating script

```
bash create.sh
```

After this, you should have a cluster provioned with docker.

To create a swarm first you need to get the internal IP of the manager node.

```
docker-machine ssh $MANAGER_NAME ifconfig eth0
```

With that IP in mind create a swarm in the manager node

```
eval $(docker-machine env $MANAGER_NAME)
docker swarm init --advertise-addr <REPLACE WITH THE IP>
```

Now we need to allow the comunication between some ports in the cluster, so first get the id from the security group-id

```
aws ec2 describe-security-groups --filter "Name=group-name,Values=$SECURITY_GROUP"
```

Then store this id in SECURITY_GROUP_ID

Personally I recommend to add in envvars.sh and reload the configuration

```
echo "export SECURITY_GROUP_ID=<PUT THE ID HERE>" >> envvars.sh
source envvars.sh
```

Then execute security_group.sh

```
bash security_group.sh
```

And finally join every node to the swarm.

To do this, modify join_swarm.sh with the command from `swarm init`

```
bash join_swarm.sh
```
