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

# Get dircolors
eval "$(dircolors ~/.dircolors)"
