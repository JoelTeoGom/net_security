#!/bin/bash

# Definir variables de configuración
server_ip="198.18.179.190"  # Última IP de la DMZ
router_ip="198.18.179.177"  # IP del router como gateway
netmask="255.255.255.240"    # Máscara de subred de la DMZ

# Configurar interfaz eth0 del servidor usando /etc/network/interfaces
cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $server_ip
    netmask $netmask
    gateway $router_ip
EOF

# Reiniciar interfaz eth0
ifdown eth0 && ifup eth0


# PRACTICA 3 MODIFICACIÓ LAB5
sed -i '/nameserver/d' /etc/resolv.conf  # Eliminar entradas anteriores de nameserver
echo "nameserver $router_ip" >> /etc/resolv.conf  # Agregar la IP del router como nameserver




# Configurar /etc/hosts en el servidor
sed -i '/router/d' /etc/hosts  # Eliminar entradas anteriores del router
echo "$router_ip router" >> /etc/hosts

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

