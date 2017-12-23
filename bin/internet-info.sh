#!/bin/bash

# Inspired by
# https://github.com/jldeen/bad-ass-terminal/blob/master/bin/internet_info.sh

if [ "$OS" = "Darwin" ]; then
    network_name="$(networksetup -getairportnetwork en0 | cut -c 24-)"
    local_ip=$(ipconfig getifaddr en0)
elif [ "$OS" = "Linux" ]; then
    if command_exists nmcli; then
        devname=$(nmcli -t -f type,device dev status | egrep '^wifi' | cut -c 6-)
        network_name="$(nmcli -t -f ap dev show $devname | grep 'SSID' | cut -c 12-)"
        local_ip=$(nmcli -t -f ip4 dev show $devname | grep 'ADDRESS' | cut -d: -f2 | cut -d/ -f1)
    fi
fi

printf "#[fg=green] %s#[fg=colour15]|#[fg=green]%s" "$network_name" "$local_ip"
