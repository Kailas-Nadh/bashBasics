#! /bin/bash
#Program to monitor rpi temperature
red='\033[0;31m'
white='\033[0;37m'
yellow='\033[0;33m'
while true
do
	#vcgencmd measure_temp
	date
	temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
	sleep 1
	echo $temp
	if [[ $temp > 70 ]] 
	then
		echo -e "${red}CRITICAL TEMPERATURE..!!! Temperature above 70'C${white}"
	elif [[ $temp > 60 ]]
	then
		echo -e "${yellow}Temperature above 60'C${white}"
	fi 
done
