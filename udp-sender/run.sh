#!/bin/bash -x
export LD_LIBRARY_PATH=/usr/local/lib
./af_xdp_user -S -d eth0
#./af_xdp_user -S -d ens9f0
