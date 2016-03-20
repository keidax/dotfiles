#!/bin/sh
#
# ~/.profile
#
# System-wide settings and variable, non-bash-specific

echo "Sourcing .profile"'!'

# Source general shell files
for DOTFILE in "env" "path" ; do
    [ -f "${DOTFILE}" ] && . ~/.dotfiles/shell/"${DOTFILE}"
done

# Source .bashrc if we're running bash
([ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]) && . "$HOME/.bashrc"

if [ "${DISTRO}" = "Arch" ]; then
    # Start an X server if we're logging in on TTY1
    ([ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]) && exec startx

    # Start fbterm if we're logging in on the linux console
    [ "$TERM" = "linux" ] && exec fbterm
fi
