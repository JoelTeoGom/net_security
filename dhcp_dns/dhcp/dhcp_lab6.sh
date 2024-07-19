#!/bin/bash

# Definir variables de configuración
dns_server="172.24.179.129"  # IP del servidor DNS local
domain_name="intranet.gsx"   # Nuestro dominio

# Configurar el servicio DHCP
sed -i '/# A list of options to set for the DHCP server/,/}/ {
/# A list of options to set for the DHCP server/! {
/}/! {
/^}/! {
/^  option domain-name ".*/d
/^  option domain-name-servers .*/d
/^  option domain-search .*/d
}
}
/# A list of options to set for the DHCP server/a \
  option domain-name "'"$domain_name"'"; \
  option domain-name-servers '"$dns_server"'; \
  option domain-search "'"$domain_name"'";' /etc/dhcp/dhcpd.conf

# Configurar el archivo /etc/resolv.conf en el contenedor DHCP
echo "nameserver $dns_server" > /etc/resolv.conf
echo "search $domain_name" >> /etc/resolv.conf

# Reiniciar el servicio DHCP
systemctl restart isc-dhcp-server

# Comprobar el estado del servicio DHCP
systemctl status isc-dhcp-server

