mount -t bpf bpf /sys/fs/bpf
df /sys/fs/bpf
ls -l /sys/fs/bpf
rm -f /sys/fs/bpf/accept_map /sys/fs/bpf/xdp_stats_map
export LD_LIBRARY_PATH=/usr/local/lib
./af_xdp_user -S -d vpeer2 -Q 0 --filename ./af_xdp_kern.o &
ns2_pid=$!
sleep 10
kill -INT ${ns2_pid}
wait
