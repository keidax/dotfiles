# Include common aliases
source_if_exists "$DOTDIR/shell/aliases"

# Can't assign '=' alias using the 'alias' builtin, but this works
aliases[=]='noglob _calc'

# Shorter shell help name
alias run-help > /dev/null && unalias run-help
alias help=run-help

# Reverse of cd
alias pd='popd > /dev/null'
