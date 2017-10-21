#!/bin/sh
#
# ~/.profile
#
# System-wide settings and variable, non-bash-specific

# Source general shell files
for file in "env" "path" "functions" ; do
    [ -f ~/.dotfiles/shell/"${file}" ] && . ~/.dotfiles/shell/"${file}"
done

# Handle termux environment
if [ "$OS" = "Android" ] && [ "$DISTRO" = "Termux" ]; then
    if is_running "proot"; then
        echo "[chroot is running]"
    else
        echo "[Starting chroot...]" && exec termux-chroot
    fi

    if is_running "sshd"; then
        echo "[sshd is running]"
    else
        echo "[Starting sshd...]" && sshd && echo "[OK]"
    fi
fi

# Source .bashrc if we're running bash
([ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]) && . "$HOME/.bashrc"

if [ "${DISTRO}" = "Arch" ]; then
    # Start an X server if we're logging in on TTY1
    ([ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]) && exec startx

    # Make sure our exit code is 0
    true
fi

# Load RVM into a shell session *as a function*
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"
