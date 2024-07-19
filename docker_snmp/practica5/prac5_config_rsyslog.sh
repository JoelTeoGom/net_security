#!/bin/bash

# Función para configurar el servidor syslog central en el servidor
configurar_servidor() {

    # Modificar /etc/rsyslog.conf des-comentant las líneas que hacen que el servidor escuche en el puerto udp 514
    sed -i '/^#module(load="imudp"/s/^#//;/^#input(type="imudp"/s/^#//;/^#  port("514")/s/^#//;/^#)/s/^#//' /etc/rsyslog.conf

cat << 'EOF' > /etc/rsyslog.d/10-remot.conf
$template GuardaRemots, "/var/log/remots/%HOSTNAME%/%timegenerated:1:10:timestamp-to-rfc3339%.log"
:source, !isequal, "localhost" -?GuardaRemots
EOF


    # Reinicia el servei rsyslog
    service rsyslog restart

}

# Función para configurar otros contenedores para enviar mensajes al servidor syslog central
configurar_contenedor() {
    # Editar /etc/rsyslog.d/90-remot.conf
    cat <<EOT >> /etc/rsyslog.d/90-remot.conf
user.* @${IPSERVER}:514
EOT

    # Reinicia el servei rsyslog
    service rsyslog restart
}

# Obtener el nombre de host del contenedor
hostname=$(hostname)

# IP del servidor syslog central
IPSERVER="198.18.179.178"


# Comprobar si el contenedor es el servidor
if [ "$hostname" = "server" ]; then
    configurar_servidor
else
    configurar_contenedor
fi
