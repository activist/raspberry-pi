#!/bin/bash

MY_PATH="`dirname \"$0\"`"              # relative
LOG_PATH="/var/log/wifi_disconnect.log"
now=$(date +"%m-%d %r")

# Which Interface do you want to check
wlan='wlan0'
# Which address do you want to ping to see if you can connect
pingip='google.com'

# Perform the network check and reset if necessary
/bin/ping -c 2 -I $wlan $pingip > /dev/null 2> /dev/null
if [ $? -ge 1 ] ; then
    echo "$now Network is DOWN. Perform a reboot" >> $LOG_PATH
    /sbin/ifdown $wlan
    sleep 10
    /sbin/ifup --force $wlan
    if [ $? -ge 1 ] ; then
        "$now Failed to restart $wlan. Rebooting"
        /sbin/reboot 1 
    fi
else
    echo "$now Network is UP. Just exit the program." >> $LOG_PATH
fi
