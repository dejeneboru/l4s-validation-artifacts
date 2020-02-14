#!/bin/bash
# ECN (1:DCTCP, 3:TCP Prague, 0: Cubic)
ECN=${1}
# Congestion control (cubic/dctcp/prague)
CC=${2}
# server IP 

SERVER_IP=${3}

# set ECN and congestion control
sudo sysctl net.ipv4.tcp_ecn=${ECN}
sudo sysctl net.ipv4.tcp_congestion_control=${CC}
sudo killall -9 iperf iperf3

rm -f "rate-log-cc-${CC}"

# start iperf/iperf3 client 

iperf3 -c ${SERVER_IP} -t 300 -i 1 > "rate-log-cc-${CC}" & 

exit