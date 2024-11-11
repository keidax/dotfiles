# Manually include rbenv completion

rbenv_root="${$(which rbenv):P:h:h}"

if [[ -f "${rbenv_root}/completions/rbenv.zsh" ]]; then
    # rbenv v1.2 and older
    source "${rbenv_root}/completions/rbenv.zsh"
else
    # rbenv v1.3+
    fpath+="${rbenv_root}/completions/"
fi

unset rbenv_root
