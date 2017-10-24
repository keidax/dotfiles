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
