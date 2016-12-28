#!/bin/bash

# Some devices to reference later.
NET_DEVICE=`ip link | grep " UP " | awk '{print $2}'`
NET_DEVICE=${NET_DEVICE/:/}
SOUND_DEVICE="Master"
DISK_DEVICE="/dev/sda3"

# Calculate network transfer speeds.
net=`ifstat -t 5 | grep "${NET_DEVICE}" | awk '{print $1, "+" $6, "-" $8}'`

# Get stats for mem, swap and disk
freestr=`free -h`
diskstr=`df -h`
mem=`echo $freestr | awk '{print "M", $9 "/" $8}'`
swap=`echo $freestr | awk '{print "S", $16 "/" $15}'`
disk=`df -h | grep "${DISK_DEVICE}" | awk '{print "D", $3 "/" $2}'`

# Get battery stats.
bat=`acpi | awk '{print $3 $4  $5}'`
bat=${bat//,/ }
bat=${bat//Unknown/}

# Get the current volume.
vol=`amixer get "${SOUND_DEVICE}" | grep "dB" | awk '{print $4 $6}'`
vol=${vol//[/}
vol=${vol//]/}
vol="Vol $vol"

# Get the current time.
time=$(date +"%a %D %H:%M:%S")

# Echo out the final result.
echo "$net | $mem $swap $disk | $bat | $vol | $time"
