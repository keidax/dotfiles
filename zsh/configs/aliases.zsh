# Include common aliases
source_if_exists "$DOTDIR/shell/aliases"

# Can't assign '=' alias using the 'alias' builtin, but this works
aliases[=]='_calc'

# Shorter shell help name
unalias run-help
alias help=run-help

# Reverse of cd
alias pd=popd
