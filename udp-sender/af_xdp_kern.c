/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>

#include <bpf/bpf_helpers.h>

//struct bpf_map_def SEC("maps") xsks_map = {
//	.type = BPF_MAP_TYPE_XSKMAP,
//	.key_size = sizeof(int),
//	.value_size = sizeof(int),
//	.max_entries = 64,  /* Assume netdev has no more than 64 queues */
//};

//struct bpf_map_def SEC("maps") xdp_stats_map = {
//	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
//	.key_size    = sizeof(int),
//	.value_size  = sizeof(__u32),
//	.max_entries = 64,
//};

struct {
	__uint(type, BPF_MAP_TYPE_XSKMAP);
	__uint(max_entries, 64);
	__type(key, int);
	__type(value, int);
} xsks_map_0 SEC(".maps") ;

struct {
	__uint(type, BPF_MAP_TYPE_XSKMAP);
	__uint(max_entries, 64);
	__type(key, int);
	__type(value, int);
} xsks_map_1 SEC(".maps") ;

//struct {
//	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
//	__uint(max_entries, 64);
//	__type(key, int);
//	__type(value, __u32);
//} xdp_stats_map SEC(".maps");

SEC("xdp_sock_0")
int xdp_sock_prog_0(struct xdp_md *ctx)
{
    int index = ctx->rx_queue_index;
//    __u32 *pkt_count;

//    pkt_count = bpf_map_lookup_elem(&xdp_stats_map, &index);
//    if (pkt_count) {
//
//        /* We pass every other packet */
//        if ((*pkt_count)++ & 1)
//            return XDP_PASS;
//    }

    /* A set entry here means that the correspnding queue_id
     * has an active AF_XDP socket bound to it. */
    if (bpf_map_lookup_elem(&xsks_map_0, &index))
        return bpf_redirect_map(&xsks_map_0, index, 0);

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
