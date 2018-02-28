#!/bin/bash
#
# Wrapper to select best available diff highlighting option

if command_exists 'diff-so-fancy'; then
    exec diff-so-fancy "$@"
elif command_exists 'diff-highlight'; then
    exec diff-highlight "$@"
else
    exec cat "$@"
fi
