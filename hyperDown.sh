# 1. Navigate to your fabric-samples test network folder
cd ~/go/src/github.com/fabric-samples/test-network

# 2. Use the official fabric script to cleanly bring the network down
./network.sh down

# 3. Clean up lingering Docker artifacts cleanly
docker ps -a -q | xargs -r docker rm -f
docker volume ls -q | xargs -r docker volume rm
docker network prune -f

# 4. Wipe out all locally generated crypto material, channel configurations, and logs
sudo rm -rf organizations/ channel-artifacts/ system-genesis-block/ log.txt *.tar.gz
git checkout -- organizations/
cd ~/go/src/github.com/fabric-samples/explorer
docker-compose down -v