#!/bin/bash

# Definir variables de configuración
router_ip="172.24.179.129"   # IP del router
domain_name="intranet.gsx"   # Nuestro dominio

# Configurar el cliente DHCP para solicitar domain-name y domain-name-servers si no están presentes
sed -i '/#send host-name/a \
send domain-name "'"$domain_name"'"; \
send domain-name-servers '"$router_ip"';' /etc/dhcp/dhclient.conf

# Bajar y levantar la interfaz eth0
ip link set dev eth0 down
ip link set dev eth0 up

# Verificar y modificar el archivo /etc/resolv.conf en el contenedor 'client'
echo "search $domain_name" > /etc/resolv.conf
echo "nameserver $router_ip" >> /etc/resolv.conf

# Comprobar visualmente el contenido de /etc/resolv.conf
cat /etc/resolv.conf

# Probar la conectividad con el servidor DNS local
ping ns

