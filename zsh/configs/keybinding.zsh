# Don't hang on ^S/^Q
setopt no_flow_control

# Minimize delay
KEYTIMEOUT=10

bindkey -v

# Accustomed binding to leave insert mode
bindkey 'jk' vi-cmd-mode

# Jump to start/end of line
bindkey          '^a' vi-beginning-of-line
bindkey -M vicmd '^a' vi-beginning-of-line
bindkey          '^e' vi-end-of-line
bindkey -M vicmd '^e' vi-end-of-line

# Let backspace delete everywhere
bindkey '^h' backward-delete-char
bindkey '^?' backward-delete-char
bindkey '^w' backward-kill-word

# Terminfo handler
function bindkey-terminfo {
    [[ -n "$terminfo[$2]" ]] && bindkey -M "$1" "$terminfo[$2]" "$3"
}

# 'Delete' key
bindkey-terminfo viins kdch1 delete-char
bindkey-terminfo vicmd kdch1 delete-char
# Shifted 'Delete' key
bindkey-terminfo viins kDC kill-word
bindkey-terminfo vicmd kDC kill-word
# Home key
bindkey-terminfo viins khome vi-beginning-of-line
bindkey-terminfo vicmd khome vi-beginning-of-line
# End key
bindkey-terminfo viins kend vi-end-of-line
bindkey-terminfo vicmd kend vi-end-of-line

# Load help for the current command/alias/builtin with Alt-H
bindkey '^[h' run-help
bindkey -M vicmd '^[h' run-help

# https://stackoverflow.com/a/35874797
function Resume {
    jobs %% >/dev/null 2>&1 && {
        # zle push-input
        fg
        zle reset-prompt
        # zle get-line
    }
}
zle -N Resume
bindkey '^f' Resume

select-word-style normal

# Allows Ctrl-W to delete one path segment at a time
zstyle ':zle:*' word-context '*/*' filename
zstyle ':zle:*kill*:filename' word-style normal
zstyle ':zle:*kill*:filename' word-chars '-_'
