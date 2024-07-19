#!/bin/bash

netmask="255.255.255.240"
intranet_netmask="255.255.255.128"
intranet_router_ip="172.24.179.129"
router_ip="198.18.179.177"  # Primera IP de la DMZ
server_ip="198.18.179.190"  # Última IP de la DMZ

# Configurar interfaz eth2 del router
ip addr add $intranet_router_ip/$intranet_netmask dev eth2
ip link set eth2 up

# Configurar SNAT para la red intranet
iptables -t nat -A POSTROUTING -s 172.24.179.128/25 -o eth0 -j MASQUERADE

# Redirigir consultas DNS hacia el servidor DNS externo desde eth2
iptables -t nat -A PREROUTING -i eth2 -d $intranet_router_ip -p udp --dport 53 -j DNAT --to-destination $external_dns_ip:53

# Redirigir consultas DNS desde la DMZ hacia el servidor DNS externo
iptables -t nat -A PREROUTING -i eth1 -d $router_ip -p udp --dport 53 -j DNAT --to-destination $external_dns_ip:53


