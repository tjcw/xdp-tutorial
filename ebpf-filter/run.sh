#!/bin/bash -x
export LD_LIBRARY_PATH=/usr/local/lib
ip tuntap add mode tun tun0
ip link set dev tun0 up
ip link set addr 10.1.0.254
./af_xdp_user -S -d enp25s0 -Q 0 --filename ./af_xdp_kern_pass.o
