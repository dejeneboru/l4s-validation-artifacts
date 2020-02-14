#!/bin/bash
# bottleneck bandwidth
RATE=$1
# interface name
IFACE=$2
# scalable congestion control (prague or dctcp)
L4S_CC=$3

# disable tso, gso, gro
sudo ethtool -K $IFACE tso off gso off gro off tx off
# delete old configuration
sudo tc qdisc del dev $IFACE root
# set HTB rate limiter
sudo tc qdisc add dev $IFACE root handle 1: htb default 1
sudo tc class add dev $IFACE parent 1: classid 1:1 htb rate ${RATE}Mbit ceil ${RATE}Mbit burst 1514 cburst 1514

if [ $L4S_CC = 'prague' ]; then
	if [ $RATE -eq 4 ]; then
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2 step_thresh 6ms 
	elif [ $RATE -eq 12 ]; then
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2 step_thresh 3ms 
	else
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2 step_thresh 1ms 
	fi
elif [ $L4S_CC ='dctcp' ]; then
	if [ $RATE -eq 4 ]; then
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2  any_ect step_thresh 6ms 
	elif [ $RATE -eq 12 ]; then
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2  any_ect step_thresh 3ms 
	else
		sudo tc qdisc add dev $IFACE parent 1:1 dualpi2 coupling_factor 2  any_ect step_thresh 1ms 
	fi
else
	echo "Undefined scalable CC"

fi




