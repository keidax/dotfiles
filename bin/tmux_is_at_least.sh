#!/usr/bin/env bash

# Copied from tmux-yank project

# Cache the TMUX version for speed.
tmux_version="$(tmux -V | cut -d ' ' -f 2)"

tmux_is_at_least() {
    if [[ $tmux_version == "$1" || $tmux_version == "master" ]]
    then
        return 0
    fi

    local IFS=.
    local i tver=($tmux_version) wver=($1)

    # fill empty fields in tver with zeros
    for ((i=${#tver[@]}; i<${#wver[@]}; i++)); do
        tver[i]=0
    done

    # fill empty fields in wver with zeros
    for ((i=${#wver[@]}; i<${#tver[@]}; i++)); do
        wver[i]=0
    done

    for ((i=0; i<${#tver[@]}; i++)); do
        if ((10#${tver[i]} < 10#${wver[i]})); then
            return 1
        fi
    done
    return 0
}

tmux_is_at_least "$@"
