#!/bin/bash

# Fitxer Dockerfile per al laboratori 5
DOCKERFILE="dockerfile_gsx_prac5"

# Nom de la imatge Docker
IMATGE="gsx:prac5"

# Construeix la imatge Docker
docker build -t $IMATGE -f $DOCKERFILE .


# Verificar que las redes se hayan creado correctamente
if docker network ls | grep -q "ISP" && docker network ls | grep -q "DMZ" && docker network ls | grep -q "INTRANET"; then
    echo "Las redes Docker se han creado correctamente."
else
    echo "¡Error! No se pudieron crear todas las redes Docker."
fi



# Define network parameters
ISP_SUBNET="10.0.2.16/30"
ISP_GATEWAY="10.0.2.17"

DMZ_SUBNET="198.18.179.176/28"
DMZ_GATEWAY="198.18.179.177"

INTRANET_SUBNET="172.24.179.128/25"
INTRANET_GATEWAY="172.24.179.129"


# Crea les xarxes ISP, DMZ i INTRANET amb els esquemes d'adreçament
docker network create --driver=bridge --subnet=10.0.2.16/30 ISP
docker network create --driver=bridge --subnet=$DMZ_SUBNET --gateway=$DMZ_GATEWAY DMZ
docker network create --driver=bridge --subnet=$INTRANET_SUBNET --gateway=$INTRANET_GATEWAY INTRANET

# Verificar que las redes se hayan creado correctamente
if docker network ls | grep -q "ISP" && docker network ls | grep -q "DMZ" && docker network ls | grep -q "INTRANET"; then
    echo "Las redes Docker se han creado correctamente."
else
    echo "¡Error! No se pudieron crear todas las redes Docker."
fi


# Run dels contenidors
OPCIONS="-itd --rm --privileged --cap-add=NET_ADMIN --cap-add=SYS_ADMIN"
IMATGE="gsx:prac5"
DIRECTORI=/home/milax/Escriptori/prac5_gsx/practica5

# Executar el contenidor Server amb un directori compartit amb l'amfitrió
docker run $OPCIONS --hostname server --network=DMZ --name Server --mount type=bind,src=$DIRECTORI,dst=/root/prac5 $IMATGE

# Verificar que el contenedor Server se haya creado correctamente
if docker ps -a --filter "name=Server" --format '{{.Names}}' | grep -q "Server"; then
    echo "El contenedor Server se ha creado correctamente."
else
    echo "¡Error! No se pudo crear el contenedor Server."
    exit 1
fi

# Executar els altres contenidors amb l'opció read-only per a tenir persistència de les dades
docker run $OPCIONS --hostname router --network=ISP --name Router --mount type=bind,ro,src=$DIRECTORI,dst=/root/prac5 $IMATGE
docker network connect DMZ Router
docker network connect INTRANET Router

docker run $OPCIONS --hostname dhcp --network=INTRANET --name DHCP --mount type=bind,ro,src=$DIRECTORI,dst=/root/prac5 $IMATGE

# Verificar que los contenedores se hayan creado correctamente
if docker ps -a --filter "name=Router" --filter "name=DHCP" --format '{{.Names}}' | grep -q "Router" && docker ps -a --filter "name=DHCP" --filter "name=Router" --format '{{.Names}}' | grep -q "DHCP"; then
    echo "Los contenedores se han creado correctamente."
else
    echo "¡Error! No se pudieron crear todos los contenedores."
    exit 1
fi


xterm -e docker attach Router &
xterm -e docker attach Server &
xterm -e docker attach DHCP &


