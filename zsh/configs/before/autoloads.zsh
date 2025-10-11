# Miscellaneous autoloads

# Hook helper functions
autoload -Uz add-zle-hook-widget add-zsh-hook

# User-configurable word definitions
autoload -Uz select-word-style
# We have to actually call the function before loading syntax-highlighting plugin
select-word-style normal

# Use more comprehensive help functions
autoload -Uz run-help{,-git,-ip,-sudo}

# Add additional function autoload locations
if [[ -d ~/.zfunc ]]; then
    fpath+=~/.zfunc
fi

if [[ -d "$HOME/.local/share/zsh/site-functions/" ]]; then
    fpath+="$HOME/.local/share/zsh/site-functions/"
fi
