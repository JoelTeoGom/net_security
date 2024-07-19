#!/bin/bash

# Funció per crear i assignar enllaços
crear_i_assignar_enllaç() {
  node1=$1
  node2=$2
  ip1=$3
  ip2=$4

  echo $node1
  echo $node2
  echo $ip1
  echo $ip2

  ip link add link${node1}_${node2}_veth1 type veth peer name link${node1}_${node2}_veth2

  pid1=$(docker inspect --format '{{.State.Pid}}' R$node1)
  pid2=$(docker inspect --format '{{.State.Pid}}' R$node2)

  ip link set netns $pid1 dev link${node1}_${node2}_veth1
  ip link set netns $pid2 dev link${node1}_${node2}_veth2

  nsenter -t $pid1 -n ip addr add $ip1 dev link${node1}_${node2}_veth1
  nsenter -t $pid2 -n ip addr add $ip2 dev link${node1}_${node2}_veth2

  nsenter -t $pid1 -n ip link set dev link${node1}_${node2}_veth1 up
  nsenter -t $pid2 -n ip link set dev link${node1}_${node2}_veth2 up
}

# Exemple de crides a la funció (adaptar segons les IPs assignades)
crear_i_assignar_enllaç 1 2 10.179.1.1/30 10.179.1.2/30
crear_i_assignar_enllaç 2 3 10.179.2.1/30 10.179.2.2/30
crear_i_assignar_enllaç 3 4 10.179.3.1/30 10.179.3.2/30
crear_i_assignar_enllaç 4 1 10.179.4.1/30 10.179.4.2/30
