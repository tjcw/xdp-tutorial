#!/bin/bash -x
ip netns add ns1
ip netns exec ns1 mount -t bpf bpf /sys/fs/bpf
ip netns add ns2
ip netns exec ns2 mount -t bpf bpf /sys/fs/bpf

ip link add veth1 type veth peer name vpeer1
ip link add veth2 type veth peer name vpeer2

ip link set veth1 up
ip link set veth2 up

ip link set vpeer1 netns ns1
ip link set vpeer2 netns ns2

ip netns exec ns1 ip link set lo up
ip netns exec ns2 ip link set lo up

ip netns exec ns1 ip link set vpeer1 up
ip netns exec ns2 ip link set vpeer2 up

ip netns exec ns1 ip addr add 10.10.0.10/16 dev vpeer1
ip netns exec ns2 ip addr add 10.10.0.20/16 dev vpeer2

ip link add br0 type bridge
ip link set br0 up

ip link set veth1 master br0
ip link set veth2 master br0

ip addr add 10.10.0.1/16 dev br0

iptables -P FORWARD ACCEPT
iptables -F FORWARD

ip netns exec ns2 ip link set dev vpeer2 xdpgeneric off
rm -f /sys/fs/bpf/accept_map /sys/fs/bpf/xdp_stats_map
ip netns exec ns2 ip tuntap add mode tun tun0
ip netns exec ns2 ip link set dev tun0 down
ip netns exec ns2 ip link set dev tun0 addr 10.10.0.30/24
ip netns exec ns2 ip link set dev tun0 up

export LD_LIBRARY_PATH=/usr/local/lib
ip netns exec ns2 ./af_xdp_user -S -d vpeer2 -Q 0 --filename ./af_xdp_kern.o &
ns2_pid=$!
sleep 2
ip netns exec ns1 ping -c 5 10.10.0.20

echo "kill -INT ${ns2_pid}"
echo "wait"
echo "ip netns delete ns1"
echo "ip netns delete ns2"
