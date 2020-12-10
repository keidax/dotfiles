# Compinit handled by zplug
# autoload -Uz compinit
# compinit

autoload -U +X bashcompinit && bashcompinit

# Allow completions in the middle of a word
setopt complete_in_word

# Display completion list immediately when inserting prefix
setopt no_list_ambiguous

# Case- and hypen-insensitive completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}'
zstyle ':completion:*' verbose 'true'

# Group completions by type and show headings
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%F{5}%B%d%b%f'

# Assign completions for custom commands
compdef _rspec rspec-branch
compdef _rubocop rubocop-branch

# Manually include rbenv completions
rbenv_root="${$(which rbenv):P:h:h}"
source "${rbenv_root}/completions/rbenv.zsh"
unset rbenv_root
