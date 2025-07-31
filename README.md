sudo apt-get update
sudo apt-get install docker.io

sudo apt-get install docker-compose

sudo usermod -aG docker $USER

make build 
make up
