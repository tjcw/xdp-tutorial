#!/bin/bash -x
ip netns add ns1

ip link add veth1 type veth peer name vpeer1

ip link set veth1 up

ip link set vpeer1 netns ns1

ip netns exec ns1 ip link set lo up

ip netns exec ns1 ip link set vpeer1 up

#ip netns exec ns1 ip addr add 10.10.0.10/16 dev vpeer1
ip netns exec ns1 ip addr add 10.1.0.253/24 dev vpeer1

ip link add br0 type bridge
ip link set br0 up

ip link set veth1 master br0
ip link set ens1 master br0

ip addr add 10.1.0.254/24 dev br0

#ip netns exec ns1 ip route add default via 10.10.0.1

iptables -P FORWARD ACCEPT
iptables -F FORWARD

export LD_LIBRARY_PATH=/usr/local/lib
ip netns exec ns1 ./af_xdp_user -d vpeer1
#gdb ./af_xdp_user
