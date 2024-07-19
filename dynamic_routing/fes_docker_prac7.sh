#!/bin/bash

# Variables
imatge="gsx:prac7"
OPCIONS="-itd --rm --privileged"

# Crear la imatge Docker
docker build -t $imatge -f dockerfile_gsx_prac7 .

# Crear els contenidors
for node in 1 2 3 4; do
  if [ "$node" -eq 1 ]; then
    docker run $OPCIONS --hostname router$node --name R$node $imatge
  else
    docker run $OPCIONS --hostname router$node --network=none --name R$node $imatge
  fi
done

# Adjuntar xterm a cada contenedor
for node in 1 2 3 4; do
  xterm -e docker attach R$node &
done

sleep 5

# Crear els enllaços veth
sudo ./crear_enllaços.sh
