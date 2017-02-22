#!/bin/bash
#
# ~/.bashrc
#

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

# Add bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
