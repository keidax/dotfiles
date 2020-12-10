setopt prompt_subst prompt_percent

# Exit codes > 128 indicate an uncaught signal. Return the name for that signal,
# because e.g. "KILL" is more semantic than "137".
full_exit_code() {
    local exit_code=$?
    if [[ $exit_code -gt 128 ]]; then
        # Indexing here is wonky, see zshparam(1)
        echo "${signals[exit_code - 127]}"
    else
        echo "$exit_code"
    fi
}

# Red error code if previous command failed
error_status="%(?..$FG[001]"'$(full_exit_code)'"$FX[reset] )"

# Blue working directory
working_directory="$FG[004]$FX[bold]"'$(shrink_path -l -t)'"$FX[reset]"

# Yellow job count with at least one job
job_count="%(1j.$FG[003]%j$FX[reset] .)"

# Lambda symbol, or pound if root
cmd_symbol="$FX[bold]%(!.#.λ)$FX[reset]"

# Build up the whole prompt.
PROMPT="${error_status}${working_directory} ${job_count}${cmd_symbol} "

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

    [[ -z $git_present || $git_present -eq 0 ]] && return

    # Nerd Font arrows:
    #   
    #   
    #   
    # Unicode arrows:
    #⭥ ⮁ ⮃ ⭡ ⭣
    # ⬍ ⇵ ↧↥ ↦ ⇿ ⇳ ⟷ ⥈ ⥮ ⥯

    if [[ $git_ahead -ne 0 && $git_behind -ne 0 ]]; then
        echo -n "$FG[005]⮁ "
    elif [[ $git_ahead -ne 0 ]]; then
        echo -n "$FG[002]⭡ "
    elif [[ $git_behind -ne 0 ]]; then
        echo -n "$FG[001]⭣ "
    fi

    [[ $git_staged -gt 0 ]] && echo -n "$FG[002]+"

    [[ $git_unstaged -gt 0 ]] && echo -n "$FG[001]*"

    [[ $git_untracked -gt 0 ]] && echo -n "$FG[001]%%"

    [[ $git_stashed -gt 0 ]] && echo -n "$FG[004]\$"

    echo -n " $FG[002]$git_branch_name$FX[reset]"
}

_aws_vault_env() {
    if [[ -n $AWS_VAULT ]]; then
        printf " %s" "$FG[016]${AWS_VAULT}$FX[reset]"
    else
        printf ""
    fi
}

_rprompt_callback() {
    local new_rprompt
    read -r -u $1 new_rprompt

    # Remove the handler and close the fd
    zle -F $1
    exec {1}<&-

    if [[ "$new_rprompt" != "$RPROMPT" ]]; then
        # Only re-eval the prompt if it changes
        RPROMPT="$new_rprompt"
        [[ -o zle ]] && zle reset-prompt
    fi
}

# zle reset-prompt doesn't seem to work on the first call unless we initialize
# RPROMPT with something.
RPROMPT=""

_rprompt_precmd() {
    # Fade out the outdated prompt
    RPROMPT="%{[02m%}$RPROMPT%{[22m%}"

    local fd
    exec {fd}< <(
        _git_format
        _aws_vault_env
    )

    zle -F $fd _rprompt_callback
}
add-zsh-hook precmd _rprompt_precmd

# Inspired by https://www.topbug.net/blog/2016/10/03/restore-the-previously-canceled-command-in-zsh/
_restore_aborted_command() {
    # Store the last non-empty aborted line
    if [[ -n $ZLE_LINE_ABORTED ]]; then
        ABORTED_LINE="$ZLE_LINE_ABORTED"
    fi

    if [[ -n $ABORTED_LINE ]]; then
        local saved_buf="$BUFFER" saved_pos="$CURSOR"
        BUFFER="$ABORTED_LINE"
        CURSOR="$#BUFFER"
        zle split-undo
        BUFFER="$saved_buf" CURSOR="$saved_pos"
    fi
}

add-zle-hook-widget line-init _restore_aborted_command

# Remove pesky right-hand space
ZLE_RPROMPT_INDENT=0
