# Miscellaneous autoloads

# Hook helper functions
autoload -Uz add-zle-hook-widget add-zsh-hook

# User-configurable word definitions
autoload -Uz select-word-style
# We have to actually call the function before loading syntax-highlighting plugin
select-word-style normal
