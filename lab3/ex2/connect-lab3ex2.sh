#!/bin/bash

echo "setting up host veth"

sudo ip link del veth1 type veth
sudo ip link add veth1 type veth
sudo ip addr flush veth0
sudo ip addr add 192.168.100.27/24 dev veth0

bridge="$(sudo docker network ls | grep -e "kathara_${USER}.*_lanA" | grep -o '^[a-z0-9]* ')"

echo
echo "attaching veth1 to lanA, bridge: kt-${bridge}"

sudo ip link set veth1 master kt-${bridge}

sudo ip link set veth0 up
sudo ip link set veth1 up
ip addr show dev veth1
ip addr show dev veth0

 
