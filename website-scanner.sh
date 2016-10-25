#!/bin/bash
ip=$1

# SOURCE: https://github.com/jgamblin/Mirai-Source-Code/blob/6a5941be681b839eeff8ece1de8b245bcd5ffb02/mirai/bot/scanner.c#L124
usernames=("root" "root" "root" "admin" "root" "root" "root" "root" "root" "root" "support" "root" "admin" "root" "root" "user" "admin" "root" "admin" "root" "admin" "admin" "root" "root" "root" "root" "Administrator" "service" "supervisor" "guest" "guest" "guest" "admin1" "administrator" "666666" "888888" "ubnt" "root" "root" "root" "root" "root" "root" "root" "root" "root" "root" "root" "root" "root" "root" "admin" "admin" "admin" "admin" "admin" "admin" "admin" "admin" "admin" "tech" "mother")
passwords=("xc3511" "vizxv" "admin" "admin" "888888" "xmhdipc" "default" "juantech" "123456" "54321" "support" "" "password" "root" "12345" "user" "" "pass" "admin1234" "1111" "smcadmin" "1111" "666666" "password" "1234" "klv123" "admin" "service" "supervisor" "guest" "12345" "12345" "password" "1234" "666666" "888888" "ubnt" "klv1234" "Zte521" "hi3518" "jvbzd" "anko" "zlxx." "7ujMko0vizxv" "7ujMko0admin" "system" "ikwb" "dreambox" "user" "realtek" "00000000" "1111111" "1234" "12345" "54321" "123456" "7ujMko0admin" "1234" "pass" "meinsm" "tech" "fucker")

hasFailed=false

# clean up used files if they exist
rm response.txt header.txt endpoint_data.txt > /dev/null 2>&1

# connect to site write out head and headers
endpoint_data=$(curl --head --silent --connect-timeout 3 $ip --show-error --output response.txt --dump-header header.txt > endpoint_data.txt 2>&1)
#endpoint_data=$(curl --head --silent $ip --show-error --output response.txt --dump-header header.txt > endpoint_data.txt 2>&1)

# check no route to host error
endpoint_no_route=`cat endpoint_data.txt | grep "No route to host" | wc -l`
if [ "$endpoint_no_route" -ne 0 ] && [ "$hasFailed" = false ]; then
	hasFailed=true
	echo -n "No route to host "
fi

# check time out error
endpoint_timeout=`cat endpoint_data.txt | grep "timed out" | wc -l`
if [ "$endpoint_timeout" -ne 0 ] && [ "$hasFailed" = false ]; then
	hasFailed=true
	echo -n "Timed out "
fi

# is authorization required
auth_required=`cat header.txt | grep "401" | wc -l`
if [ "$auth_required" -ne 1 ] && [ "$hasFailed" = false ]; then
	hasFailed=true
	echo -n "Authorization not required "
fi

if [ "$hasFailed" = false ]; then
	for ((i=0;i<${#usernames[@]};++i)); do
		access_granted=`curl --head --silent ${usernames[i]}:${passwords[i]}@$ip | grep "200 OK" | wc -l`
		if [ "$access_granted" -ne 0 ]; then
			echo -n "WARNING: access granted u/${usernames[i]} p/${passwords[i]} "
		fi
	done
fi
