#!/bin/bash

# Definir el valor de LLINDAR
LLINDAR=10


# IP del router
ROUTER_IP="198.18.179.179"

# Realizar las consultas SNMP para obtener los valores de los OIDs
IN_SET_REQUESTS=$(snmpget -v2c -c public $ROUTER_IP SNMPv2-MIB::snmpInSetRequests | awk '{print $NF}')
IN_GET_REQUESTS=$(snmpget -v2c -c public $ROUTER_IP SNMPv2-MIB::snmpInGetRequests | awk '{print $NF}')

# Verificar si el incremento supera el umbral definido
if [ $IN_SET_REQUESTS -gt 0 ] && [ $IN_GET_REQUESTS -gt $LLINDAR ]; then
    # Calcular el incremento
    INCREMENT=$(($IN_GET_REQUESTS - $LLINDAR))
    # Enviar un mensaje al syslog local
    logger -p user.warning -t GSX "AVÍS: el valor del SNMPv2-MIB::snmpInGetRequests al router ha aumentado demasiado: $IN_GET_REQUESTS (+$INCREMENT)"
fi


