for ((i=1; i<=$NUM_WORKERS; i++))
do
echo "Joining the swarm in the node ${SWARM_WORKERS_PREFIX}${i}"
eval $(docker-machine env ${SWARM_WORKERS_PREFIX}${i})
docker swarm join --token ${TOKEN} --listen-addr $(docker-machine ip ${SWARM_WORKERS_PREFIX}${i}) --advertise-addr $(docker-machine ip ${SWARM_WORKERS_PREFIX}${i})  ${MANAGER_IP}:2377
done
