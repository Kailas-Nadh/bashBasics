#!/bin/bash
# Program to monitor RPi temperature

red='\033[0;31m'
white='\033[0;37m'
yellow='\033[0;33m'

while true
do
    # Get the temperature
    temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')

    # Compare the temperature and take action
    if (( $(echo "$temp > 70") )); then
        echo -e "${red}CRITICAL TEMPERATURE..!!! Temperature above 70°C${white}"
        # Send a system-level warning
        # Using notify-send for graphical desktop notifications (if available)
        if command -v notify-send &> /dev/null; then
            notify-send "Temperature Alert" "CRITICAL TEMPERATURE: Temperature above 70°C"
        fi
        # Log the warning to system log
        logger "CRITICAL TEMPERATURE: Temperature above 70°C"
    elif (( $(echo "$temp > 60"))); then
        echo -e "${yellow}Temperature above 60°C${white}"
    fi 

    # Wait for 1 second before checking again
    sleep 1
done
