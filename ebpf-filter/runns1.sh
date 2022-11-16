#!/bin/bash -x

ip netns exec ns1 ip link set lo up

ip netns exec ns1 ip link set vpeer1 up

ip netns exec ns1 ip addr add 10.10.0.10/16 dev vpeer1
sleep 6
ip netns exec ns1 ping -c 5 10.10.0.20

