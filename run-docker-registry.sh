#!/bin/bash

# Registry ready?
if ! docker ps -a --filter "name=^registry$" --format "{{.Names}}" | grep -q "^registry$"; then
  docker run -d -p 5000:5000 --restart=always --name registry -v /opt/registry:/var/lib/registry -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io registry:2.7
fi

# Proxy as mirror
if [ ! -f /etc/docker/daemon.json ]; then
  systemctl stop docker.socket
  systemctl stop docker
  echo '{"registry-mirrors": ["http://localhost:5000"]}' | tee /etc/docker/daemon.json > /dev/null
  systemctl start docker
else
  if ! grep -q '"registry-mirrors": \["http://localhost:5000"\]' /etc/docker/daemon.json; then
    systemctl stop docker.socket
    systemctl stop docker
    echo '{"registry-mirrors": ["http://localhost:5000"]}' | tee -a /etc/docker/daemon.json > /dev/null
    systemctl start docker
  fi
fi

# Download image
docker pull localhost:5000/ccesitull/esit-ia:0.0.2
