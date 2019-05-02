# Compinit handled by zplug
# autoload -Uz compinit
# compinit

# Allow completions in the middle of a word
setopt complete_in_word

# Display completion list immediately when inserting prefix
setopt no_list_ambiguous

# Case- and hypen-insensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}'

# Assign completions for custom commands
compdef _rspec rspec-branch
compdef _rubocop rubocop-branch
