#!/bin/bash

# Comandos para probar el acceso a los MIBs y obtener información del sistema

# Variables para la versión SNMP, la comunidad y el host
SNMP_VERSION="2c"
COMMUNITY="public"
HOST="localhost"

snmptranslate -Td -OS UCD-SNMP-MIB::ucdavis.dskTable

echo "Obteniendo información del sistema:"
# Consulta de la información del sistema
snmpwalk -v $SNMP_VERSION -c $COMMUNITY $HOST system

echo "Obteniendo información de recursos humanos del sistema:"
# Consulta de la información de recursos humanos del sistema
snmpwalk -v $SNMP_VERSION -c $COMMUNITY $HOST hrSystem

echo "Probando el acceso a los MIBs de la Univ. California Davis:"
# Consulta de la tabla de procesos de la Univ. California Davis
snmptable -v $SNMP_VERSION -c cilbup $HOST UCD-SNMP-MIB::prTable

# Consulta de la tabla de discos de la Univ. California Davis
snmptable -v $SNMP_VERSION -c cilbup $HOST ucdavis.dskTable

# Consulta de la tabla de carga promedio de la Univ. California Davis
snmptable -v $SNMP_VERSION -c cilbup $HOST ucdavis.laTable
