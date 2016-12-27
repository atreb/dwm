#!/bin/bash

# Some devices to reference later.
mixer="Master"
mixer_channel="Front Left"
netdevice="wlo1"

# Calculate network transfer speeds.
netspeeds=$(ifstat -t 5 | grep $netdevice);
downspeed=$(echo $netspeeds | awk '{print $6}')
upspeed=$(echo $netspeeds | awk '{print $8}')
downspeed=$(expr $downspeed / 1024)
upspeed=$(expr $upspeed / 1024)
net=$(printf "+ %0dK - %0dK" "$downspeed" "$upspeed")

# Get the current time.
time=$(date +"%c")

# Get battery stats.
acpi=$(acpi)
batstate=$(echo ${acpi} | awk '{print $3}')
batperc=$(echo ${acpi} | awk '{print $4}')
battime=$(echo ${acpi} | awk '{print $5}')
batperc=${batperc/,/}
bat="Batt ${batperc}"
[ "${batstate}" == "Discharging," ] && bat="${bat} ($battime)"

# Get CPU usage.
loadavgs=$(uptime | awk -F 'load average:' '{print $2}' | awk '{print $2}')
loadavg=${loadavgs/,/}
cpu="Cpu ${loadavg}"

# Get current RAM usage.
maxmem=`free -m | grep "Mem" | awk '{print $2}'`
usedmem=`free -m | grep "Mem" | awk '{print $3}'`
buffmem=`free -m | grep "buffers/cache" | awk '{print $3}'`
usedmem=$(($usedmem - $buffmem))
usedmem=`expr $usedmem \* 100`
percmem=`expr $usedmem / $maxmem`
mem="Ram $percmem%"

# Get the current volume.
vol=`amixer get "${mixer}" | grep "${mixer_channel}:" | awk '{print $5}'`
if [ "$vol" == "0%" ]
then 
    vol="Mute"
else
    vol=${vol/\[/}
    vol=${vol/\]/}
fi
snd="Vol $vol"

# Echo out the final result.
#echo "$net :: $cpu :: $mem :: $bat :: $snd :: $time "
echo "$net  |  $cpu |  $mem  |  $bat  |  $snd  |  $time "

