#!/bin/bash

CLICK_FIFO=$(mktemp -u)
WAKE_FIFO=$(mktemp -u)
mkfifo "$CLICK_FIFO" "$WAKE_FIFO"
trap "rm -f '$CLICK_FIFO' '$WAKE_FIFO'; kill 0; exit" EXIT INT TERM

# relay swaybar click events from stdin into the click fifo
cat > "$CLICK_FIFO" &
CAT_PID=$!

# handle clicks in background, signal main loop to refresh
{
    while read -r line; do
        name=$(echo "$line" | jq -r '.name // empty' 2>/dev/null)
        case "$name" in
            network) nm-connection-editor & ;;
            volume)  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        esac
        # wake up main loop to refresh
        echo x > "$WAKE_FIFO"
    done
} < "$CLICK_FIFO" &
CLICK_PID=$!

get_battery() {
    local cap status icon
    cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
    status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
    if [ -z "$cap" ]; then
        echo ""
        return
    fi
    case "$status" in
        Charging) icon="CHG" ;;
        Full)     icon="FULL" ;;
        *)        icon="BAT" ;;
    esac
    echo "$icon $cap%"
}

get_volume() {
    local vol mute
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%.0f", $2 * 100}')
    mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q MUTED && echo "MUTE" || echo "")
    if [ -z "$vol" ]; then
        echo ""
        return
    fi
    [ "$mute" = "MUTE" ] && echo "VOL MUTE" || echo "VOL $vol%"
}

get_brightness() {
    local bri max pct
    bri=$(brightnessctl g 2>/dev/null)
    max=$(brightnessctl m 2>/dev/null)
    if [ -z "$bri" ] || [ -z "$max" ] || [ "$max" -eq 0 ]; then
        echo ""
        return
    fi
    pct=$((bri * 100 / max))
    echo "BRI $pct%"
}

get_cpu() {
    local cpu
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%.0f", 100 - $8}')
    [ -z "$cpu" ] && cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}')
    echo "CPU ${cpu:-?}%"
}

get_ram() {
    local used total pct
    read -r _ total _ <<< $(grep MemTotal /proc/meminfo)
    read -r _ avail _ <<< $(grep MemAvailable /proc/meminfo)
    if [ -z "$total" ] || [ -z "$avail" ]; then
        echo ""
        return
    fi
    used=$((total - avail))
    pct=$((used * 100 / total))
    echo "RAM ${pct}%"
}

echo '{"version":1,"click_events":true}'
echo '['

while true; do
    batt=$(get_battery)
    vol=$(get_volume)
    bri=$(get_brightness)
    cpu=$(get_cpu)
    ram=$(get_ram)
    clock=$(date '+%Y-%m-%d %H:%M')

    parts=()
    parts+=("{\"full_text\":\" NET \",\"name\":\"network\",\"separator\":true,\"separator_block_width\":8}")
    [ -n "$cpu" ]  && parts+=("{\"full_text\":\" $cpu \"}")
    [ -n "$ram" ]  && parts+=("{\"full_text\":\" $ram \"}")
    [ -n "$bri" ]  && parts+=("{\"full_text\":\" $bri \"}")
    [ -n "$vol" ]  && parts+=("{\"full_text\":\" $vol \",\"name\":\"volume\",\"separator\":true,\"separator_block_width\":8}")
    [ -n "$batt" ] && parts+=("{\"full_text\":\" $batt \"}")
    parts+=("{\"full_text\":\" $clock \"}")

    joined=$(IFS=,; echo "${parts[*]}")
    echo "[$joined],"

    # sleep 3s or wake on click
    read -r -t 3 _ < "$WAKE_FIFO"
done
