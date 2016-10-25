#!/bin/bash
network=$1
start_address=$2
end_address=$3
start_port=$4
end_port=$5

for i in $(seq $start_address $end_address); do
	ip=$network.$i
    echo -n "Scanning $ip "
    complete_packet_loss=`ping -c 5 $ip | grep "100% packet loss" | wc -l`

    if [ "$complete_packet_loss" -ne 1 ]; then	# if you can ping the box then
    	./port-scanner.sh $ip $start_port $end_port | tee ports.txt
		ports=`cat ports.txt`

		webpage_requiring_authentication=`echo $ports | grep :80 | wc -l`
		if [ "$webpage_requiring_authentication" -ne 0 ]; then
			./website-scanner.sh $ip
		fi
	else
    	echo -n "no pong "
    fi
	echo "Done"
done
