#!/bin/bash

SEP=" | "

while true; do
    SYS_TIME=$(date "+%d.%m.%Y %H:%M")

    BAT_PATH="/sys/class/power_supply/BAT1"
    if [ ! -d "$BAT_PATH" ]; then
        BAT_PATH="/sys/class/power_supply/BAT0"
    fi

    if [ -d "$BAT_PATH" ]; then
        BAT_PERC=$(cat "$BAT_PATH/capacity")
        BAT_STAT=$(cat "$BAT_PATH/status")

        case "$BAT_STAT" in
            "Charging")    BAT_STR="⚡ $BAT_PERC%" ;;
            "Discharging") BAT_STR="🔋 $BAT_PERC%" ;;
            *)             BAT_STR="🔌 $BAT_PERC%" ;;
        esac
    else
        BAT_STR="NO BAT"
    fi

    MEM_STR=$(free -h | awk '/^Mem:/ {print "RAM: " $3 "/" $2}')

    CPU_LOAD=$(awk '{print "CPU: " $1}' /proc/loadavg)

    TEMP_STR=$(awk '{for(i=1;i<=NF;i++) if($i~/^[0-9]+$/ && $i>m) m=$i} END {printf "TMP: %.0f°C", m/1000}' /sys/class/thermal/thermal_zone*/temp 2>/dev/null)
    [ -z "$TEMP_STR" ] && TEMP_STR="TMP: N/A"

    echo "$TEMP_STR$SEP$CPU_LOAD$SEP$MEM_STR$SEP$BAT_STR$SEP$SYS_TIME"

    sleep 5
done
