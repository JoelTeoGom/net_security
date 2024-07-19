#!/bin/bash

# Nombres de los nodos
nodos=(R1 R2 R3 R4)

# Ejecutar el script para cada nodo
for nodo in "${nodos[@]}"; do
    docker exec $nodo /root/prac7_config_rip.sh
done
