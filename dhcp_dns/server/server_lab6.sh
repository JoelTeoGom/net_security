#!/bin/bash

# Modificar temporalmente el archivo /etc/resolv.conf con un servidor DNS genérico
sed -i '/nameserver/d' /etc/resolv.conf  # Eliminar entradas anteriores de nameserver
echo "nameserver 1.1.1.1" | tee -a /etc/resolv.conf  # Agregar Cloudflare DNS como nameserver

# Comprobar e instalar paquetes necesarios para BIND9
if ! dpkg -s bind9 bind9-doc dnsutils &> /dev/null; then
    # Si los paquetes no están instalados, instalarlos
    apt-get update
    apt-get install -y bind9 bind9-doc dnsutils
fi

# Copiar los archivos de configuración de BIND9 al directorio local
cp /etc/bind/named* /home/server/tmp/

# Modificar el archivo /etc/default/named para atender solo peticiones IPv4 (-4)
sed -i '/OPTIONS/c\OPTIONS="-4"' /etc/default/named

# Editar el archivo named.conf.options
sed -i '/^directory/c\directory "/var/cache/bind";' /home/server/tmp/named.conf.options
sed -i '/^forwarders/c\    forwarders { <IP_DNS_ISP>; };' /home/server/tmp/named.conf.options
sed -i '/^allow-recursion/c\    allow-recursion { <IP_REDMZ>; };' /home/server/tmp/named.conf.options
sed -i '/^allow-transfer/c\    allow-transfer { localhost; };' /home/server/tmp/named.conf.options
sed -i '/^auth-nxdomain/c\    auth-nxdomain no;' /home/server/tmp/named.conf.options
sed -i '/^dnssec-validation/c\    dnssec-validation no;' /home/server/tmp/named.conf.options
sed -i '/^listen-on-v6/c\    listen-on-v6 { none; };' /home/server/tmp/named.conf.options

# Editar el archivo named.conf.local
cat <<EOF > /home/server/tmp/named.conf.local
zone "intranet.gsx" {
    type master;
    file "/etc/bind/db.intranet.gsx";
};

zone "dmz.gsx" {
    type master;
    file "/etc/bind/db.dmz.gsx";
};

zone "128.172.in-addr.arpa" {
    type master;
    file "/etc/bind/db.172.128";
};

zone "179.18.in-addr.arpa" {
    type master;
    file "/etc/bind/db.18.179";
};
EOF

# Verificar la sintaxis de los archivos de configuración y de zona
/sbin/named-checkconf
/sbin/named-checkzone intranet.gsx /home/server/tmp/db.intranet.gsx
/sbin/named-checkzone dmz.gsx /home/server/tmp/db.dmz.gsx
/sbin/named-checkzone 128.172.in-addr.arpa /home/server/tmp/db.172.128
/sbin/named-checkzone 179.18.in-addr.arpa /home/server/tmp/db.18.179

# Cambiar las propiedades de los archivos
chmod --reference=/etc/bind/named.conf* /home/server/tmp/named.conf*
chown --reference=/etc/bind/named.conf* /home/server/tmp/named.conf*
cp /home/server/tmp/named.conf* /etc/bind/
cp /home/server/tmp/db.* /var/cache/bind/

# Reiniciar el servicio BIND9 como daemon
systemctl restart bind9

# Modificar el archivo /etc/resolv.conf para configurar el nameserver como localhost y el search de los dominios
sed -i '/nameserver/c\nameserver 127.0.0.1' /etc/resolv.conf
sed -i '/search/c\search intranet.gsx dmz.gsx' /etc/resolv.conf

