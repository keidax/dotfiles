#!/bin/sh

# Inspired by
# https://github.com/jldeen/bad-ass-terminal/blob/master/bin/internet_info.sh

if [ "$OS" = "Darwin" ]; then
    network_name=$(networksetup -getairportnetwork en0 | cut -c 24-)
    local_ip=$(ipconfig getifaddr en0)
fi

printf "#[fg=green] %s#[fg=colour15]|#[fg=green]%s" "$network_name" "$local_ip"
