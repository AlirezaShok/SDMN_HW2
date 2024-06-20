#!/bin/bash
# deleting the namespaces and topology if already existed
sudo ip -all netns delete
sudo ip link delete vbr1
sudo ip link delete vbr2

# creating different namespaces for nodes and router
sudo ip netns add node1
sudo ip netns add node2
sudo ip netns add node3
sudo ip netns add node4
sudo ip netns add router

# creating links from nodes to bridges
sudo ip link add veth0-h1 type veth peer name veth0-b1
sudo ip link add veth0-h2 type veth peer name veth1-b1
sudo ip link add veth0-h3 type veth peer name veth0-b2
sudo ip link add veth0-h4 type veth peer name veth1-b2
# creating links from router to bridges
sudo ip link add veth0-r type veth peer name veth2-b1
sudo ip link add veth1-r type veth peer name veth2-b2

# creating the bridges
sudo ip link add br1 type bridge 
sudo ip link add br2 type bridge 
# making bridges up
sudo ip link set dev br1 up
sudo ip link set dev br2 up

# connecting links to nodes
sudo ip link set veth0-h1 netns node1
sudo ip link set veth0-h2 netns node2
sudo ip link set veth0-h3 netns node3
sudo ip link set veth0-h4 netns node4
# connecting links to router
sudo ip link set veth0-r netns router
sudo ip link set veth1-r netns router
# connecting links to bridges
sudo ip link set veth0-b1 master br1
sudo ip link set veth1-b1 master br1
sudo ip link set veth2-b1 master br1
sudo ip link set veth0-b2 master br2
sudo ip link set veth1-b2 master br2
sudo ip link set veth2-b2 master br2

# assigning IP to nodes
sudo ip -n node1 addr add 172.0.0.2/24 dev veth0-h1
sudo ip -n node2 addr add 172.0.0.3/24 dev veth0-h2
sudo ip -n node3 addr add 10.10.0.2/24 dev veth0-h3
sudo ip -n node4 addr add 10.10.0.3/24 dev veth0-h4 
# assigning IP to router
sudo ip -n router addr add 172.0.0.1/24 dev veth0-r 
sudo ip -n router addr add 10.10.0.1/24 dev veth1-r

# making node interfaces up
sudo ip -n node1 link set veth0-h1 up
sudo ip -n node2 link set veth0-h2 up
sudo ip -n node3 link set veth0-h3 up
sudo ip -n node4 link set veth0-h4 up
# making bridge interfaces up
sudo ip link set veth0-b1 up
sudo ip link set veth1-b1 up
sudo ip link set veth2-b1 up
sudo ip link set veth0-b2 up
sudo ip link set veth1-b2 up
sudo ip link set veth2-b2 up
# making router interfaces up
sudo ip -n router link set veth0-r up
sudo ip -n router link set veth1-r up

# making the loop-back interface of the namespaces up
sudo ip -n node1 link set lo up
sudo ip -n node2 link set lo up
sudo ip -n node3 link set lo up
sudo ip -n node4 link set lo up
sudo ip -n router link set lo up

# enabling IP-forwarding in router 
sudo ip netns exec router sysctl -w net.ipv4.ip_forward=1

# adding routing rules for nodes
sudo ip netns exec node1 ip route add 10.10.0.0/24 via 172.0.0.1
sudo ip netns exec node2 ip route add 10.10.0.0/24 via 172.0.0.1  
sudo ip netns exec node3 ip route add 172.0.0.0/24 via 10.10.0.1 
sudo ip netns exec node4 ip route add 172.0.0.0/24 via 10.10.0.1 
