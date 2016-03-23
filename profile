#!/bin/sh
#
# ~/.profile
#
# System-wide settings and variable, non-bash-specific

# Source general shell files
for file in "env" "path" ; do
    [ -f ~/.dotfiles/shell/"${file}" ] && . ~/.dotfiles/shell/"${file}"
done

# Source .bashrc if we're running bash
([ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]) && . "$HOME/.bashrc"

if [ "${DISTRO}" = "Arch" ]; then
    # Start an X server if we're logging in on TTY1
    ([ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]) && exec startx

    # Start fbterm if we're logging in on the linux console
    [ "$TERM" = "linux" ] && exec fbterm
fi
