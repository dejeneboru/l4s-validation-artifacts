#!/bin/bash

# MY_IP=$1

DST_IP=$1
# congestion control
CC=$2
# SERVER_IP (IP of server A or B)
rm -f cwnd_*

ttime=0

while [ $ttime -le 3100 ]
do
  line=$( ss -t -i -p -n state established "src ${SERVER_IP}:5201 dst ${DST_IP}"  | grep -v "Send-Q\|TIME-WAIT\|FIN-WAIT-1\|SYN-RECV\|FIN-WAIT-2")
  if [ -z "$line" ]; then
    echo $line >> /dev/null 
  else
    if [ $CC = 'cubic' ] ; then 
      echo $line  >> cwnd_classic
    else
      echo $line  >> cwnd_l4s
    fi
  fi
  sleep 0.1
  ttime=$((ttime+1))
  
done

