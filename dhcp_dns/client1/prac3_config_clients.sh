#!/bin/bash

# Configurar el archivo /etc/dhcp/dhclient.conf
cat <<EOF > /etc/dhcp/dhclient.conf
# Configuración del cliente DHCP

# Enviar el nombre del host al servidor DHCP
send host-name = gethostname();

# Solicitar un tiempo de arrendamiento de un día
request dhcp-lease-time 86400;
EOF

# Reiniciar la interfaz eth0 para obtener la configuración DHCP
ifdown eth0 && ifup eth0

# Esperar unos segundos para que se complete la configuración DHCP
sleep 5

# Mostrar la configuración obtenida
echo "Configuración obtenida:"
echo "-----------------------"
echo "Dirección IP: $(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
echo "Gateway predeterminado: $(ip route show | grep default | awk '{print $3}')"
echo "Servidores de nombres DNS: $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')"

# Mostrar el tiempo de arrendamiento obtenido
echo "Tiempo de arrendamiento obtenido:"
cat /var/lib/dhcp/dhclient.eth0.leases

