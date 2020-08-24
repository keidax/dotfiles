source ~/.zplug/init.zsh

# Extra completions
zplug "zsh-users/zsh-completions"

# Reminders for aliases
zplug "djui/alias-tips"

# FZF bindings
zplug "~/", use:".fzf.zsh", from:local

# Improved command-line syntax highlighting
zplug "zdharma/fast-syntax-highlighting"

# Set current directory in terminal tab title
zplug "modules/terminal", from:prezto
zstyle ':prezto:module:terminal' auto-title 'yes'

# 256-color and attribute arrays
zplug "lib/spectrum", from:oh-my-zsh

# Abbreviated path helper
zplug "plugins/shrink-path", from:oh-my-zsh

# Autocompletion
zplug "zsh-users/zsh-autosuggestions"

# Expand `...` into `../..`, etc
zplug "knu/zsh-manydots-magic", use:manydots-magic, defer:2

# Docker completions
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

zplug load
