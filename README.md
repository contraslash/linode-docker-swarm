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

### Create a registry

First we need to create a machine provisioned with docker, to do this we can execute `create_registry.sh`

```
bash create_registry.sh
```

Then log in the registry machine and execute the next tasks

```
# First we're going to need a SSL cert, and we recommend to use certbot
sudo add-apt-repository ppa:certbot/certbot

sudo apt-get update

sudo apt-get install certbot

letsencrypt certonly --keep-until-expiring --standalone -d registry.example.combine --email info@finantic.co

# Enter to the letsencrypt's certs directory
cd /etc/letsencrypt/live/registry.example.com/

# Then we need to combine cert.pem and chain.pem to create a domain.crt
cat cert.pem chain.pem > domain.crt
# And for legibility purposes rename privkey.pem to domain.key
cp privkey.pem domain.key
```

> This is taked from [here](https://gist.github.com/PieterScheffers/63e4c2fd5553af8a35101b5e868a811e)

The last step is to create users to login to the registry

```
htpasswd -Bbn user password >> /data/registry/auth/htpasswd
```

With the certs ready, we just execute the new registry container

```
docker run -d -p 5000:5000 \
  --restart=always \
  --name registry   \
  -v /data/registry/auth:/auth \
  -e REGISTRY_AUTH="htpasswd"   \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"   \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd   \
  -v /etc/letsencrypt/live/registry.finantic.co:/certs   \
  -v /data/registry/registry:/var/lib/registry   \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt   \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key   \
  registry:2
```

> Troubleshooting

After removing a machine and recreating a machine with the same name you get this error:

```
Error with pre-create check: "There is already a keypair with the name <Machine name>.  Please either remove that keypair or use a different machine name."
```

Go to AWS Console -> EC2 -> Network & Security -> Key Pairs and Delete the keys
