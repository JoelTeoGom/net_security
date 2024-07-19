#!/bin/bash

# Definir variables de configuración
netmask="255.255.255.240"
router_ip="198.18.179.177"  # Primera IP de la DMZ
server_ip="198.18.179.190"  # Última IP de la DMZ

# Configurar interfaz eth1 del router usando iproute2
ip addr add $router_ip/$netmask dev eth1
ip link set eth1 up

# Activar IPv4 forwarding de forma permanente

sed -i "s/#net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/" /etc/sysctl.conf
sysctl -p

# Verificar si la regla de iptables ya está presente
if ! iptables -t nat -C POSTROUTING -s 198.18.179.176/28 -o eth0 -j MASQUERADE &> /dev/null; then
    # Si la regla no está presente, agregarla
    iptables -t nat -A POSTROUTING -s 198.18.179.176/28 -o eth0 -j MASQUERADE
fi

# Configurar /etc/hosts en el router
sed -i '/server/d' /etc/hosts  # Eliminar entradas anteriores del servidor
echo "$server_ip server" >> /etc/hosts

# Verificar si SSH está instalado y en ejecución
if ! dpkg -s openssh-server &> /dev/null; then
    # Si SSH no está instalado, instalarlo
    apt-get update
    apt-get install -y openssh-server
fi

# Permitir el acceso remoto al usuario root
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl restart ssh


