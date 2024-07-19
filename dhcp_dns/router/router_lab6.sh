#!/bin/bash

# Definir variables de configuración
dns_server="198.18.179.190"  # IP del servidor DNS local

# Configurar el cliente DHCP para preferir el servidor de nombres y los dominios locales
echo "prepend domain-name-servers $dns_server;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-search intranet.gsx dmz.gsx;" >> /etc/dhcp/dhclient.conf

# Filtrar las consultas DNS salientes que no provienen del servidor DNS local
iptables -A FORWARD -i eth0 -p udp --dport 53 ! -s $dns_server -j DROP

# Redirigir todas las consultas DNS entrantes en eth0 hacia el servidor DNS local
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 53 -j DNAT --to-destination $dns_server:53

# Reiniciar el servicio de red para aplicar los cambios
systemctl restart networking

# Comprobar el contenido del resolv.conf
cat /etc/resolv.conf

