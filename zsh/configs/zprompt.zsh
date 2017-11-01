# Indicate vi mode with cursor shape
# https://emily.st/2013/05/03/zsh-vi-cursor/

function zle-keymap-select zle-line-init
{
    case $KEYMAP in
        vicmd)      print -n -- "\E[2 q";;  # block cursor
        viins|main) print -n -- "\E[6 q";;  # line cursor
    esac
}

function zle-line-finish
{
    print -n -- "\E[2 q"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# Ensure proper substitutions
setopt prompt_subst prompt_percent

# Red error code if previous command failed
error_status="%(?..$FG[001]%?$FX[reset] )"

# Blue working directory
working_directory="$FG[004]$FX[bold]"'$(shrink_path -l -t)'"$FX[reset]"

# Yellow job count with at least one job
job_count="%(1j.$FG[003]%j$FX[reset] .)"

# Lambda symbol, or pound if root
cmd_symbol="$FX[bold]%(!.#.λ)$FX[reset]"

# Build up the whole prompt; note ${(e)...} is used for the working directory
# to force re-evaluation of the `shrink_path` command substitution.
PROMPT='$error_status${(e)working_directory} $job_count$cmd_symbol '

# Set up VCS prompt
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info

# Only need git for now
zstyle ':vcs_info:*' enable git

zstyle ':vcs_info:*' formats \
    "%c%u"'$_extra_git_format_str'"$FG[005]⦗$FG[002]%b$FG[005]⦘%f"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "$FG[002]+"
zstyle ':vcs_info:*' unstagedstr "$FG[001]*"

_is_git() {
    git rev-parse --is-inside-work-tree &>/dev/null
}

_extra_git_format() {
    _extra_git_format_str=""
    _is_git || return

    # Red '%' for untracked files
    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        _extra_git_format_str+="$FG[001]%%"
    fi

    # Blue '$' for saved stashes
    if [[ -s $(git rev-parse --git-dir)/logs/refs/stash ]]; then
        _extra_git_format_str+="$FG[004]\$"
    fi
}

_ruby_info() {
    # Nerd font ruby icons:     
    local ruby_str=" $FG[001] "

    command_exists rvm-prompt || return

    # Skip for default system ruby
    [[ $(rvm-prompt s) == system ]] && return

    # Indicate JRuby
    [[ $(rvm-prompt i) == j* ]] && ruby_str+="j"

    ruby_str+="$(rvm-prompt v s)$FX[reset]"
    echo "$ruby_str"
}

_extra_env_info() {
    _extra_env_info_str=""
    _extra_env_info_str+="$(_ruby_info)"
}

add-zsh-hook precmd _extra_git_format
add-zsh-hook precmd _extra_env_info

RPROMPT='${(e)vcs_info_msg_0_}${_extra_env_info_str}'

# Remove pesky right-hand space
# ZLE_RPROMPT_INDENT=0
