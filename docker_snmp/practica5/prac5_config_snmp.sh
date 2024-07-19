#!/bin/bash

# Archivo de configuración de SNMP
SNMP_CONF="/etc/snmp/snmpd.conf"


# 1. Comentar la línea actual del loopback y agregar la nueva dirección de agente para recibir UDPs desde cualquier máquina
sed -i 's/^agentaddress/#&/' $SNMP_CONF  # Comentar la línea existente del loopback
sed -i '/^# agentaddress/ a\agentAddress udp:161' $SNMP_CONF  # Agregar la nueva dirección de agente para recibir UDPs desde cualquier máquina

# 2. Modificar el sysLocation y el sysContact según corresponda
sed -i 's/^sysLocation.*/sysLocation Tarragona/' $SNMP_CONF
sed -i 's/^sysContact.*/sysContact Joel Teodoro <joel.teodoro@estudiants.urv.cat>/' $SNMP_CONF

# 3. Agregar la vista vistagsx para permitir el acceso a las ramas específicas del MIB
sed -i '/^# Views/ a\view vistagsx included .1.3.6.1.2.1.2' $SNMP_CONF
sed -i '/^view vistagsx included .1.3.6.1.2.1.2/ a\view vistagsx included .1.3.6.1.2.1.4' $SNMP_CONF
sed -i '/^view vistagsx included .1.3.6.1.2.1.4/ a\view vistagsx included .1.3.6.1.2.1.11' $SNMP_CONF
sed -i '/^view vistagsx included .1.3.6.1.2.1.11/ a\view vistagsx included .1.3.6.1.2.1.5' $SNMP_CONF
sed -i '/^view vistagsx included .1.3.6.1.2.1.5/ a\view vistagsx included .1.3.6.1.4.1.2021' $SNMP_CONF

# 4. Agregar el community string cilbup para acceso de solo lectura a la vista systemonly solo desde el localhost
sed -i '/^# rocommunity/ a\rocommunity  cilbup  localhost  -V vistagsx' $SNMP_CONF


cat <<EOT >> /etc/snmp/snmpd.conf
# Process Monitoring
proc  mountd
proc sshd
proc named 10 1
proc dhcpd
proc rsyslog
#proc apache2 4 1

# Disk Monitoring
disk       /     10000
disk       /var  5%
includeAllDisks  10%

# System Load
load   12 10 5
EOT



# Reiniciar el servicio SNMP para aplicar los cambios
service snmpd restart


######################################################################################################################################################

# Ruta al archivo de configuración de SNMP para los clientes
SNMP_CLIENT_CONF="/etc/snmp/snmp.conf"

# Establecer el path de las MIBs y especificar qué MIBs queremos (todos)
echo "mibs +ALL" > $SNMP_CLIENT_CONF

# Reiniciar el servicio SNMP para aplicar los cambios
service snmpd restart


