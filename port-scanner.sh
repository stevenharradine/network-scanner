#!/bin/bash
ip=$1
portscanner_start_port=$2
portscanner_end_port=$3

portscanner_backticks="\b\b\b\b\b"
echo -n "00000"

for i in $(seq $portscanner_start_port $portscanner_end_port); do
  portscanner_port="${i}"

  if [ $portscanner_port -lt 10 ]; then
    portscanner_port_padding="0000"
  elif [ $portscanner_port -lt 100 ]; then
    portscanner_port_padding="000"
  elif [ $portscanner_port -lt 1000 ]; then
    portscanner_port_padding="00"
  elif [ $portscanner_port -lt 10000 ]; then
    portscanner_port_padding="0"
  fi
  echo -ne "$portscanner_backticks$portscanner_port_padding$portscanner_port"

  echo "quit" | telnet $ip $portscanner_port > telnet.txt 2>&1
  open_port_found=`cat telnet.txt | grep "Escape character is" | wc -l`
  if [ "$open_port_found" -ne 0 ]; then
    echo -ne "$portscanner_backticks:$portscanner_port $portscanner_port_padding$portscanner_port"
  fi
done
echo -ne "$portscanner_backticks     $portscanner_backticks"