#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bring in aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Get dircolors
eval $(dircolors ~/.dircolors)

## Prompt setup ##

# Generate color variables
# Using tput is more portable than writing the terminal codes directly.
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)

# Export jobs as <running>|<stopped>
function jobscount(){
    stopped_cnt=$(jobs -s | wc -l)
    running_cnt=$(jobs -r | wc -l)
    if [ $stopped_cnt -eq 0 -a $running_cnt -eq 0 ]; then
	export _NUM_JOBS=""
    else
        export _NUM_JOBS="$running_cnt|$stopped_cnt "
    fi
}

# Trim working directory to last 3 dirs
function trim_wd {
    export _TRIMMED_PWD=$(echo ${PWD} | sed "s&${HOME}&~&" | sed "s&.*./\([^/]*/[^/]*/[^/]*\)$&…/\1&")
}

# Recalculate running jobs and working directory for every prompt
function prompt_command {
    jobscount
    trim_wd
}

PROMPT_COMMAND=prompt_command

# Finally, assign PS1. Output is:
# - Previous exit code, if nonzero
# - Username
# - Shortened working directory
# - Number of running and suspended jobs attached to this shell
#
# Colors are wrapped in \[ \] escapes, because they are nonprintable.

PS1='\[$RED\]$([[ $? -eq 0 ]] || echo  "$? ")\[$GREEN\]\u \[$BLUE$BOLD\]$_TRIMMED_PWD \[$YELLOW\]$_NUM_JOBS\[$RESET\]λ '

if [[ $TERM != "*dvtm*" && -z $_NESTED ]]; then
    export _NESTED="1"
    #abduco -A main bash
    #dtach -A /tmp/main dvtm
fi

# Get ibus working
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

