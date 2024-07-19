#!/bin/bash

# Definir variables de configuración
router_ip="172.24.179.129"  # IP del router como gateway
netmask="255.255.255.128"    # Máscara de subred de la intranet
dhcp_range="172.24.179.130 172.24.179.254"  # Rango de direcciones DHCP

# Configurar interfaz eth0 del servidor usando /etc/network/interfaces
cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 172.24.179.254
    netmask $netmask
    gateway $router_ip
EOF

# Reiniciar interfaz eth0
ifdown eth0 && ifup eth0

# Configurar /etc/resolv.conf en el servidor temporalmente
echo "nameserver $router_ip" > /etc/resolv.conf

# Verificar si el paquete isc-dhcp-server está instalado y si no, instalarlo
if ! dpkg -s isc-dhcp-server &> /dev/null; then
    apt-get update
    apt-get install -y isc-dhcp-server
fi

# Configurar el archivo /etc/default/isc-dhcp-server para que escuche en eth0
sed -i '/INTERFACESv4/d' /etc/default/isc-dhcp-server
echo "INTERFACESv4=\"eth0\"" >> /etc/default/isc-dhcp-server

# Configurar el archivo /etc/dhcp/dhcpd.conf
cat <<EOF > /etc/dhcp/dhcpd.conf
# Configuración del servidor DHCP para la red de intranet

# Opciones globales
default-lease-time 7200;  # Tiempo de arrendamiento predeterminado (2 horas)
max-lease-time 28800;      # Tiempo máximo de arrendamiento (8 horas)

# Definición de la red de intranet
subnet 172.24.179.128 netmask $netmask {
    range $dhcp_range;
    option routers $router_ip;  # Gateway predeterminado
    option domain-name-servers $router_ip;  # Servidor de nombres (temporalmente el router)
}
EOF

# Comprobar manualmente si hay errores de sintaxis en dhcpd.conf
/usr/sbin/dhcpd -t -cf /etc/dhcp/dhcpd.conf

# Reiniciar el servicio isc-dhcp-server
systemctl restart isc-dhcp-server

# Comprobar el estado del servicio isc-dhcp-server
journalctl --unit=isc-dhcp-server

