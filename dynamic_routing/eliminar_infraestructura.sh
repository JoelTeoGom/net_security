#!/bin/bash

# Array de nombres de contenedores
containers=("R1" "R2" "R3" "R4")

# Detener y eliminar los contenedores
for container in "${containers[@]}"
do
    if docker ps -a | grep -q $container; then
        echo "Deteniendo contenedor $container..."
        docker stop $container

        echo "Eliminando contenedor $container..."
        docker rm $container
    else
        echo "Contenedor $container no encontrado."
    fi
done

# Eliminar interfaces veth si existen
for node in 1 2 3 4
do
    if ip link show | grep -q "link${node}_veth1"; then
        echo "Eliminando interfaz link${node}_veth1..."
        sudo ip link delete link${node}_veth1
    fi
    if ip link show | grep -q "link${node}_veth2"; then
        echo "Eliminando interfaz link${node}_veth2..."
        sudo ip link delete link${node}_veth2
    fi
done

echo "Infraestructura eliminada."
