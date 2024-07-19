#!/bin/bash

# Primera consulta SNMP con el usuario gsxAdmin (autenticación y privacidad)
snmpget -v3 -l authPriv -u gsxAdmin -A aut74915993 -a SHA -X sec74915993 -x DES 198.18.179.178 sysUpTime.0 

# Segunda consulta SNMP con el usuario gsxViewer (autenticación sin privacidad)
snmpget -v3 -l authNoPriv -u gsxViewer -A aut74915993 -a SHA 198.18.179.178 sysUpTime.0 



echo "Prueba con auth incorrectas"

snmpget -v3 -l authNoPriv -u gsxViewer -A aut7491599 -a SHA 198.18.179.178 sysUpTime.0 

# Segunda consulta SNMP con el usuario gsxViewer (autenticación sin privacidad)
snmpget -v3 -l authNoPriv -u gsxViewer -A aut7491599 -a SHA 198.18.179.178 sysUpTime.0 



echo "Prueba con ip incorrectas"

snmpget -v3 -l authNoPriv -u gsxViewer -A aut7491599 -a SHA 198.18.179.17 sysUpTime.0 

# Segunda consulta SNMP con el usuario gsxViewer (autenticación sin privacidad)
snmpget -v3 -l authNoPriv -u gsxViewer -A aut7491599 -a SHA 198.18.179.17 sysUpTime.0 


#este fichero se ejecuta en la máquina remota para realizar peticiones SNMP a la máquina local.
#En este caso, se realizan dos peticiones SNMP con diferentes usuarios y se comprueba que se pueden realizar correctamente.
#Además, se realizan dos peticiones con credenciales incorrectas para comprobar que no se pueden realizar las peticiones.
#Finalmente, se realizan dos peticiones con IP incorrectas para comprobar que no se pueden realizar las peticiones.ç
#Si se ejecuta correctamente, se mostrarán los resultados de las peticiones SNMP realizadas. Si no se ejecuta correctamente, se mostrarán los errores correspondientes.