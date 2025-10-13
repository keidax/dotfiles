# $DOTDIR/shell/functions already loaded by zshenv

if [[ -x ~/.nodenv/bin/nodenv ]]; then
    # Set up nodenv as a function, along with path modifications
    eval "$(~/.nodenv/bin/nodenv init - --no-rehash zsh)"
fi
