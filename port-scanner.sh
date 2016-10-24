#!/bin/bash
ip=$1

portscanner_ports=({79..81})

for ((i=0;i<${#portscanner_ports[@]};++i)); do
	echo "quit" | telnet $ip ${portscanner_ports[i]} > telnet.txt 2>&1
	open_port_found=`cat telnet.txt | grep "Escape character is" | wc -l`
	if [ "$open_port_found" -ne 0 ]; then
		echo -n ":${portscanner_ports[i]} "
	fi
done
