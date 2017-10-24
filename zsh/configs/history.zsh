HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# Keep only the most recent occurence of a command in the history
setopt hist_ignore_all_dups

# Command lines starting with a space are not saved in history
setopt hist_ignore_space

# Save commands to the history file as they are entered
setopt inc_append_history
