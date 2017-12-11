# Indicate vi mode with cursor shape
# Inspired by https://emily.st/2013/05/03/zsh-vi-cursor/
_cursor_shape_beam() {
    print -n -- "\E[6 q"
}

_cursor_shape_block() {
    print -n -- "\E[2 q"
}

_set_cursor_type() {
    case $KEYMAP in
        vicmd)      _cursor_shape_block;;
        viins|main) _cursor_shape_beam;;
    esac
}

zle -N _cursor_shape_block
zle -N _set_cursor_type

add-zle-hook-widget line-init     _set_cursor_type
add-zle-hook-widget keymap-select _set_cursor_type
add-zle-hook-widget line-finish   _cursor_shape_block


_focus_report_on() {
    print -n -- "\E[?1004h"
}

_focus_report_off() {
    print -n -- "\E[?1004l"
}

add-zle-hook-widget line-init   _focus_report_on
add-zle-hook-widget line-finish _focus_report_off

bindkey -v '\e[O' _cursor_shape_block
bindkey -a '\e[O' _cursor_shape_block
bindkey -v '\e[I' _set_cursor_type
bindkey -a '\e[I' _set_cursor_type
