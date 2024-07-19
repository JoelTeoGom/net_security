#!/bin/bash

# Configuració del servei zebra
echo "" > /etc/quagga/zebra.conf

# Configuració del servei ripd
cat <<EOF > /etc/quagga/ripd.conf
router rip
 version 2
 network 10.179.1.0/30
 network 10.179.2.0/30
 network 10.179.3.0/30
 network 10.179.4.0/30
EOF

# Configuració específica per R1
if [ "$(hostname)" == "router1" ]; then
  cat <<EOF >> /etc/quagga/ripd.conf
 default-information originate
 passive-interface eth0
EOF
fi

# Ajustar els permisos i reiniciar els serveis
chown -R quagga.quaggavty /etc/quagga/
chmod 640 /etc/quagga/*.conf

service zebra restart
service ripd restart
