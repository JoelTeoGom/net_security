#!/bin/bash

echo "Deteniendo el servicio SNMP..."
snmpd -f -Lo -u Debian-snmp -g Debian-snmp -Dusm,usm.user >> sortida_snmp_remota_prac5.txt


echo "El servicio SNMP se ha detenido y se ha reiniciado en primer plano con opciones de depuración."



#prueba_remoto.sh y remoto.sh son scripts que se ejecutan en la máquina remotas diferentes. 
#El primero se encarga de escuchar las peticiones SNMP y el segundo de realizar peticiones SNMP a la máquina remota.
#En este caso, el script remoto.sh se encarga de detener el servicio SNMP y reiniciarlo en primer plano con opciones de depuración.
