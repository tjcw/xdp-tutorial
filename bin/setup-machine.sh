#!/bin/bash -x
git submodule update --init
sudo apt install clang llvm libelf-dev libpcap-dev gcc-multilib build-essential m4 linux-tools-$(uname -r) linux-headers-$(uname -r) linux-tools-common linux-tools-generic tcpdump
