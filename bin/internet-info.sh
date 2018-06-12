#!/bin/bash

# Inspired by
# https://github.com/jldeen/bad-ass-terminal/blob/master/bin/internet_info.sh

if [ "$OS" = "Darwin" ]; then
    # Try Wi-Fi
    network_name="$(networksetup -getairportnetwork en0 | grep "^Current" |  cut -c 24-)"
    if [ -n "$network_name" ]; then
        # Connected to Wi-Fi
        local_ip=$(ipconfig getifaddr en0)
    else
        # Try Ethernet
        local_ip="$(networksetup -getinfo "Thunderbolt Ethernet" | awk '/^IP address/ {print $3}')"
        if [ -n "$local_ip" ]; then
            network_name="Ethernet"
        fi
    fi
elif [ "$OS" = "Linux" ]; then
    if command_exists nmcli; then
        devname=$(nmcli -t -f type,device dev status | grep -e '^wifi' | cut -c 6-)
        network_name="$(nmcli -t -f general dev show "$devname" | grep 'CONNECTION' | cut -d: -f2)"
        local_ip=$(nmcli -t -f ip4 dev show "$devname" | grep 'ADDRESS' | cut -d: -f2 | cut -d/ -f1)
    elif command_exists /sbin/iw && command_exists ip; then
        devname=$(/sbin/iw dev | grep 'Interface' | cut -d' ' -f2)
        network_name="$(/sbin/iw dev "$devname" link | grep 'SSID' | cut -c 8-)"
        local_ip=$(ip addr show "$devname" | awk '/inet / {print $2}' | cut -d/ -f1)
    fi
elif [ "$OS" = "Android" ]; then
    if command_exists termux-wifi-connectioninfo && command_exists jq; then
        info="$(termux-wifi-connectioninfo)"
        network_name="$(echo "$info" | jq -r '.ssid')"
        local_ip=$(echo "$info" | jq -r '.ip')
    fi
fi

if [ -n "$local_ip" ] && [ -z "$network_name" ]; then
    network_name="<No Name>"
fi

if [ -n "$local_ip"  ] && [ -n "$network_name" ]; then
    printf "#[fg=green]%s#[fg=colour15]|#[fg=green]%s" "$network_name" "$local_ip"
else
    printf "#[fg=colour16]%s" "No Connection"
fi
