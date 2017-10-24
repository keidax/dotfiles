# Don't hang on ^S/^Q
setopt no_flow_control

# Minimize delay
KEYTIMEOUT=10

bindkey -v

# Accustomed binding to leave insert mode
bindkey 'jk' vi-cmd-mode

# Jump to start/end of line
bindkey '^a' vi-beginning-of-line
bindkey '^e' vi-end-of-line

# Let backspace delete everywhere
bindkey '^h' backward-delete-char
bindkey '^?' backward-delete-char
bindkey '^w' backward-kill-word

# https://stackoverflow.com/a/35874797
function Resume {
    fg
    zle push-input
    BUFFER=""
    zle accept-line
}
zle -N Resume
bindkey '^f' Resume
