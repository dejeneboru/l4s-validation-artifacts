#!/bin/bash

IFACE =$1

tstart=1
rm -f queue_stat*

touch queue_stat

while [ $tstart -le 2950 ]
do
	tc -s -d  qdisc show dev ${IFACE} >> queue_stat
	sleep 0.1
	tstart=$(( tstart + 1 ))
done

exit