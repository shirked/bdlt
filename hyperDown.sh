cd ~/go/src/github.com/fabric-samples/test-network
./network.sh down
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls -q)
docker network prune -f
cd ~/go/src/github.com/fabric-samples/test-network
sudo rm -rf organizations/ channel-artifacts/ system-genesis-block/ log.txt *.tar.gz
git checkout -- organizations/
cd ~/go/src/github.com/fabric-samples/explorer
docker-compose down -v
