#!/bin/bash
# Simple netem script that gets delay correct on an
# interface symmetrically
# we *don't trust* netem to set a rate. Use htb + something on another
# interface entirely to set a rate. Also note that the limit is large,
# but arbitrarily so. Always check to see if netem dropped anything on
# longer RTT tests.


# One way delay (1/2 RTT)
ONE_WAY_DELAY=${1}ms
# Interface name
IFACE=$2

sudo modprobe ifb
sudo modprobe act_mirred
ext=${IFACE}
ext_ingress=ifb${IFACE}

sudo ethtool -K ${IFACE} tso off gso off gro off tx off
sudo ethtool -K ${ext_ingress} tso off gso off gro off tx off

sudo tc qdisc del dev ${ext} root
sudo tc qdisc del dev ${ext_ingress} root

sudo ip link add ${ext_ingress} type ifb
sudo ifconfig ${ext_ingress} up
sudo tc qdisc add dev ${ext} root netem delay ${ONE_WAY_DELAY} limit 40000
sudo tc qdisc add dev ${ext} handle ffff: ingress
sudo tc qdisc add dev ${ext_ingress} root netem delay ${ONE_WAY_DELAY}  limit 40000

# Forward all ingress traffic to the IFB device
sudo tc filter add dev ${ext} parent ffff: protocol all u32 match u32 0 0 action mirred egress redirect dev ${ext_ingress}
tc -s qdisc show dev ${IFACE}

