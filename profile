#!/bin/sh
#
# ~/.profile
#
# System-wide settings and variable, non-bash-specific

# Determine OS
case "$(uname)" in
    Linux)
        OS="Linux" ;;
    Darwin)
        OS="OSX" ;;
    *)
        OS="Unknown" ;;
esac

# Try several different methods to determine the Linux distro
if [ -n "${OS}" ] && [ "${OS}" = "Linux" ]; then
    # Check for the lsb_release command
    if [ -x "$(command -v lsb_release)" ]; then
        case "$(lsb_release --id --short)" in
            Ubuntu)
                DISTRO="Ubuntu" ;;
            Arch)
                DISTRO="Arch" ;;
            *)
                DISTRO="Unknown" ;;
        esac
    # Check for os-release (part of systemd)
    elif [ -r "/etc/os-release" ]; then
        # Match on the ID field of the os-release file
        case "$(grep "ID" /etc/os-release | cut -d = -f 2)" in
            arch)
                DISTRO="Arch" ;;
            ubuntu)
                DISTRO="Ubuntu" ;;
            *)
                DISTRO="Unknown" ;;
        esac
    # Try other /etc/*-release files (might want to expand the list)
    elif [ -f /etc/arch-release ]; then
        DISTRO="Arch"
    # Chrome OS has the /etc/lsb-release file, but not the lsb_release command
    elif ([ -f /etc/lsb-release ] && grep -q -i "chromeos" /etc/lsb-release); then
        DISTRO="ChromeOS"
    else
        DISTRO="Unknown"
    fi
fi

export OS
export DISTRO

EDITOR=vim
export EDITOR
QT_STYLE_OVERRIDE=GTK+
export QT_STYLE_OVERRIDE

# Get ibus working
GTK_IM_MODULE=ibus
export GTK_IM_MODULE
XMODIFIERS=@im=ibus
export XMODIFIERS
QT_IM_MODULE=ibus
export QT_IM_MODULE

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ "${DISTRO}" = "Arch" ]; then
    # Start an X server if we're logging in on TTY1
    ([ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]) && exec startx

    # Start fbterm if we're logging in on the linux console
    [ "$TERM" = "linux" ] && exec fbterm
fi
