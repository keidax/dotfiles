#!/bin/bash
#
# Wrapper to select best available diff highlighting option

patch=0

if [[ "$1" == "--patch" ]]; then
    patch=1
    shift
fi

if command_exists 'diff-so-fancy'; then
    if [[ $patch -ne 0  ]]; then
        exec diff-so-fancy --patch "$@"
    else
        exec diff-so-fancy "$@"
    fi
elif command_exists 'diff-highlight'; then
    exec diff-highlight "$@"
else
    exec cat "$@"
fi
