#/bin/sh

bat() {
    echo -n "BAT: $(cat /sys/class/power_supply/BAT0/capacity) 🔋"
}

tim() {
    echo -n  "$(date '+%d-%m-%Y') 📅 $(date '+%H:%M') 🕛"
}

status () { 
    echo -n "$(bat) | $(tim)"
}

while :; do
	
	xsetroot -name "$(status);left status;right status"
    # echo "$(status)"
	sleep 1m

done

