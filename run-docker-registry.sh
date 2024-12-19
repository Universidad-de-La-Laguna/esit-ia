#!/bin/bash

# Registry ready?
if ! docker ps -a --filter "name=^registry$" --format "{{.Names}}" | grep -q "^registry$"; then
  docker run -d -p 5000:5000 --restart=always --name registry -v /opt/registry:/var/lib/registry -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io registry:2.7
fi

# Proxy as mirror
CONFIG_FILE="/etc/docker/daemon.json"

DESIRED_CONFIG='{
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  },
  "registry-mirrors": ["http://localhost:5000"]
}'

MODIFY=false

if [ ! -f "$CONFIG_FILE" ]; then
  # Creando archivo daemon.json con la configuración deseada...
  echo "$DESIRED_CONFIG" > "$CONFIG_FILE"
  MODIFY=true
else
  CURRENT_CONFIG=$(cat "$CONFIG_FILE")
  if [ "$CURRENT_CONFIG" != "$DESIRED_CONFIG" ]; then
    # Actualizando archivo daemon.json con la configuración deseada...
    echo "$DESIRED_CONFIG" > "$CONFIG_FILE"
    MODIFY=true
  fi
fi

if [ "$MODIFY" = true ]; then
  # Reiniciando Docker para aplicar los cambios...
  systemctl stop docker.socket || true
  systemctl stop docker
  systemctl start docker
fi

# Download image
docker pull ccesitull/esit-ia:0.0.3
