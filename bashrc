#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source bash-specific files
for file in ~/.dotfiles/bash/{options,prompt,aliases,functions} ; do
    [ -f "${file}" ] && . "${file}"
done

# Base16 Shell
BASE16_SHELL="$HOME/.dotfiles/base16/base16-shell/base16-default.dark.sh"
[[ -s "$BASE16_SHELL" ]] && source "$BASE16_SHELL"

# Get dircolors
eval "$(dircolors ~/.dircolors)"
