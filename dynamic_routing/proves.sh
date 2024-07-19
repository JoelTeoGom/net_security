#!/bin/bash

# Router que no sea R1
ROUTER=R4

# Comprobación de los daemons en ejecución
echo "Comprobando los daemons en ejecución en $ROUTER:"
docker top $ROUTER

# Comprobación de la tabla de enrutamiento actualizada con información de zebra
echo "Comprobando la tabla de enrutamiento actualizada con información de zebra en $ROUTER:"
docker exec $ROUTER ip -c route | tee -a sortida_prac7.txt

# Acceso a la interfaz de configuración de Quagga (vtysh)
echo "Accediendo a la interfaz de configuración de Quagga (vtysh) en $ROUTER:"
docker exec -ti $ROUTER vtysh -c "show running-config" -c "show ip route" -c "show ip rip status" -c "exit" | tee -a sortida_prac7.txt

# Comprobación de las IPs y rutas hacia $ROUTER
echo "Comprobando las IPs y rutas hacia $ROUTER:"
docker exec $ROUTER ip -c address

# Elegir una de las IPs de $ROUTER
IPdestiROUTER=10.179.4.1

# Comprobación de conectividad desde R1 hacia la IP de destino
echo "Comprobando la conectividad desde R1 hacia la IP de destino:"
docker exec R1 ping -c 1 $IPdestiROUTER
docker exec R1 traceroute -n $IPdestiROUTER | tee -a sortida_prac7.txt

# Comprobación de traceroute desde $ROUTER hacia la IP de destino
echo "Comprobando traceroute desde $ROUTER hacia la IP de destino:"
docker exec $ROUTER traceroute -n -T $IPdestiROUTER | tee -a sortida_prac7.txt


link="link4_1_veth1"
# Forzar la caída de un enlace en esta ruta
echo "Forzando la caída de un enlace en esta ruta:"
echo "Bajando la interfaz $link ..."
docker exec R4 ip link set dev $link down | tee -a sortida_prac7.txt

# Esperar a que la ruta no sea la predeterminada (no sea hacia Internet)
echo "Esperando a que la ruta no sea la predeterminada (no sea hacia Internet):"
docker exec R1 ip route get $IPdestiROUTER
docker exec R1 traceroute -n $IPdestiROUTER | tee -a sortida_prac7.txt




