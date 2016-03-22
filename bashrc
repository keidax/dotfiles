#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source bash-specific files
for DOTFILE in ~/.dotfiles/bash/{options,prompt,aliases} ; do
    [ -f "${DOTFILE}" ] && . "${DOTFILE}"
done

# Get dircolors
eval "$(dircolors ~/.dircolors)"

if [[ $TERM != "*dvtm*" && -z $_NESTED ]]; then
    export _NESTED="1"
    #abduco -A main bash
    #dtach -A /tmp/main dvtm
fi

