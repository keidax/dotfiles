#!/bin/bash
#
# ~/.bashrc
#

# Load RVM into a bash session (even non-interactive)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# If not running interactively, don't do anything else
[[ $- != *i* ]] && return

# Source bash-specific files
for file in ~/.dotfiles/bash/{options,prompt,aliases,functions,completions} ; do
    [ -f "${file}" ] && . "${file}"
done

# Base16 Shell
BASE16_SHELL="$HOME/.dotfiles/base16/base16-shell/"
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Get dircolors
eval "$(dircolors ~/.dircolors)"
