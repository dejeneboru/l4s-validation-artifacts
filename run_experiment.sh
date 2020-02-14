#!/bin/bash

# IP addresses of clients/servers and the AQM node
# EXAMPLE IP address 
IP_CLIENT_A=10.10.8.20 
IP_CLIENT_B=10.10.8.30
IP_SERVER_A=10.10.1.20
IP_SERVER_B=10.10.1.30
NETEM_IFACE=10.10.1.11
AQM_IFACE=10.10.8.11

username='my_username'


# fq enable (1) or disabled (0)
for enable_fq in 0 1
do 
  # scalable congestion controls

  for l4s_cc in 'dctcp' 'prague'
  do  

    # Bottleneck bandwidths(bw) 
    for bw in 40 120 200 4 12
    do
      #RTTs
      for delay in 10 20 5 50 100 
      do
        
        # one way delay

        ONE_WAY_DELAY=$( echo "scale=2;  $delay/2.0" | bc )

        if [ ${l4s_cc} = 'prague' ]; then
          ssh ${IP_SERVER_A} 'bash -s' < run_on_server 3 prague ${enable_fq} ${IP_CLIENT_A}& 
          ssh ${IP_SERVER_B} 'bash -s' < run_on_server 0 cubic 0 ${IP_CLIENT_B} &
        elif [ ${l4s_cc} = 'dctcp' ]; then
          ssh ${IP_SERVER_A} 'bash -s' < run_on_server 1 dctcp ${enable_fq} ${IP_CLIENT_A} &
          ssh ${IP_SERVER_B} 'bash -s' < run_on_server 0 cubic 0 ${IP_CLIENT_B} & 
        fi

        ./config_aqm ${bw} ${AQM_IFACE} ${l4s_cc}
        ./netemdelay ${ONE_WAY_DELAY} ${NETEM_IFACE} 

        sleep 1  

        if [ ${l4s_cc} = 'prague' ] ; then 
          ssh  ${IP_CLIENT_A} 'bash -s' < run_on_client 3 prague ${IP_SERVER_A} &
          sleep 1
          ssh  ${IP_CLIENT_B} 'bash -s' < run_on_client 0 cubic ${IP_SERVER_B} &
        elif [ ${l4s_cc} = 'dctcp' ]; then
          ssh  ${IP_CLIENT_A} 'bash -s' < run_on_client 1 dctcp ${IP_SERVER_A} &
          sleep 1
          ssh  ${IP_CLIENT_B} 'bash -s' < run_on_client 0 cubic ${IP_SERVER_B} &
        fi

        ./queue_stats.sh &

        sleep 300

        mkdir -p 'bw-$bw-rtt-$delay-${l4s_cc}-vs-cubic'
        # rate/throughput of clients
        scp  ${IP_CLIENT_A}:/home/${username}/'rate-log-cc-${l4s_cc}'
        scp  ${IP_CLIENT_B}:/home/${username}/'rate-log-cc-cubic'
        # congestion window log
        scp ${IP_SERVER_A}:/home/${username}/cwnd_l4s 
        scp ${IP_SERVER_B}:/home/${username}/cwnd_classic 

        mv cwnd_classic cwnd_l4s queue_stat 'rate-log-cc-cubic' 'rate-log-cc-${l4s_cc}' 'bw-$bw-rtt-$delay-${l4s_cc}-vs-cubic'
       
      done 

    done

    ttoday=$(date +"%Y-%m-%d")

    mkdir  -p 'Test-${l4s-cc}-vs-cubic-fq-${enable_fq}-${ttoday}'
    mv 'bw-'* 'Test-${l4s-cc}-vs-cubic-fq-${enable_fq}-${ttoday}'

  done

done 

	       