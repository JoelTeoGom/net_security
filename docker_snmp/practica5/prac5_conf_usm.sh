#!/bin/bash

# Definir el DNI y calcular IND (DNI al revés)
DNI="39951947"
IND=$(echo "$DNI" | rev)
SNMP_CONF="/etc/snmp/snmpd.conf"
# Escriure el contingut del fitxer snmpd.conf amb les passphrases generades
cat << EOF >> $SNMP_CONF
# Creació d'usuaris SNMPv3 amb autenticació SHA i xifratge DES
createUser gsxViewer SHA "aut$IND"
createUser gsxAdmin SHA "aut$IND" DES "sec$IND"

# Especificació de l'accés per als usuaris
rouser gsxViewer authNoPriv
rwuser gsxAdmin authPriv
EOF

echo "Fitxer snmpd.conf generat amb èxit."
