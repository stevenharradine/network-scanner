#!/bin/bash
range=("192.168.1."{50..100})

for ip in "${range[@]}"
do
   : 
    echo -n "Scanning $ip "
    complete_packet_loss=`ping -c 5 $ip | grep "100% packet loss" | wc -l`

    if [ "$complete_packet_loss" -ne 1 ]; then	# if you can ping the box then
    	./port-scanner.sh $ip | tee ports.txt
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
