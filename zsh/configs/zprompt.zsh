# Indicate vi mode with cursor shape
# Inspired by https://emily.st/2013/05/03/zsh-vi-cursor/
_set_cursor_type() {
    case $KEYMAP in
        vicmd)      print -n -- "\E[2 q";;  # block cursor
        viins|main) print -n -- "\E[6 q";;  # line cursor
    esac
}

# Return to a block cursor when leaving ZLE
_unset_cursor_type() {
    print -n -- "\E[2 q"  # block cursor
}

add-zle-hook-widget line-init _set_cursor_type
add-zle-hook-widget keymap-select _set_cursor_type
add-zle-hook-widget line-finish _unset_cursor_type

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

_git_format() {
    eval $("$DOTDIR/bin/git-parse-status.sh")

    [[ $git_present -eq 0 ]] && return

    #   
    #   
    #   
    if [[ $git_ahead -ne 0 && $git_behind -ne 0 ]]; then
        echo -n "$FG[005]"
    elif [[ $git_ahead -ne 0 ]]; then
        echo -n "$FG[002]"
    elif [[ $git_behind -ne 0 ]]; then
        echo -n "$FG[001]"
    fi

    [[ $git_staged -gt 0 ]] && echo -n "$FG[002]+"

    [[ $git_unstaged -gt 0 ]] && echo -n "$FG[001]*"

    [[ $git_untracked -gt 0 ]] && echo -n "$FG[001]%%"

    [[ $git_stashed -gt 0 ]] && echo -n "$FG[004]\$"

    echo -n " $FG[002]$git_branch_name$FX[reset]"
}

# Top-level async job
# Expect to receive the current directory as $1
_rprompt_job() {
    builtin cd "$1"
    _git_format
}

_rprompt_callback() {
    RPROMPT="$3"
    [[ -o zle ]] && zle reset-prompt
}

# This forks to start the worker, so any job commands must already be defined
async_start_worker rprompt_worker
async_register_callback rprompt_worker _rprompt_callback

_start_rprompt_job() {
    async_flush_jobs rprompt_worker
    async_job rprompt_worker _rprompt_job "$PWD"
}
add-zsh-hook precmd _start_rprompt_job

# Remove pesky right-hand space
# ZLE_RPROMPT_INDENT=0
