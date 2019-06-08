#!/bin/bash
#
# ~/.bashrc
#

# Load functions (necessary for some non-interactive scripts)
[ -f "$DOTDIR/bash/functions" ] && . "$DOTDIR/bash/functions"

# If not running interactively, don't do anything else
[[ $- != *i* ]] && return

# Source bash-specific files
for file in "$DOTDIR"/bash/{options,prompt,aliases,completions} ; do
    source_if_exists "$file"
done

# Base16 Shell
BASE16_SHELL="$DOTDIR/base16/base16-shell/"
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"

# Get dircolors
eval "$(dircolors ~/.dircolors)"

# Add fzf bindings
source_if_exists ~/.fzf.bash

# Add quick foreground binding
bind -x '"\C-f":"fg"'
bind -m "vi-command" -x '"\C-f":"fg"'
