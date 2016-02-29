# When using sudo, use alias expansion
alias sudo='sudo -E '

# ls personalizations
alias ls='ls --quoting-style=literal --color=auto'
alias ll='ls -l'
alias la='ls -al'

alias syssus='systemctl suspend'
alias syshib='systemctl hibernate'

# Set TERM to something more normal over ssh
alias ssh='TERM=xterm-256color ssh '
