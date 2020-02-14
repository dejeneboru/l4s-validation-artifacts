#!/bin/bash
# ECN (1:DCTCP, 3:TCP Prague, 0: Cubic)
ECN=$1
# Congestion control (cubic/dctcp/prague)
CC=$2
enableFQ=$3
IFACE=$4

CLIENT_IP=$5


# set ECN and congestion control
sudo sysctl net.ipv4.tcp_ecn=${ECN}
sudo sysctl net.ipv4.tcp_congestion_control=${CC}

# Enable FQ for experiments (with fair queuing)

if [ ${enableFQ} -eq 1 ]; then 
	sudo tc qdisc del dev ${IFACE} root
	sudo tc qdisc add dev ${IFACE} root fq
fi


sudo killall -9 iperf iperf3
# start iperf3/iperf server 
iperf3 -s > /dev/null & 

./trace_cwnd.sh ${CC} ${CLIENT_IP} & 

exit



