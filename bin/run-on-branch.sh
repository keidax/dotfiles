#!/usr/bin/env bash

# Run a command against all the files changed in a branch, optionally matching a
# pattern.
#
# Synopsis:
#   run-on-branch [--base <branch>] [--path <path>] <command>
#                 [<args-for-comand> ...] [-- <more-args> ...]
#
# Options:
#   <comand>
#       The command to run. Should accept any number of files as arguments.
#   --base <branch>
#       Compare the current working tree agains the given branch or commit.
#       Defaults to master.
#   --path <path-or-glob>
#       Pass the given path or pattern to git diff, to restrict the compared
#       files. May be given multiple times.
#   --
#       All further options are passed directly to <command>.

BASE=master
PATHS=()
COMMAND=
COMMAND_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --base)
            BASE="$2"
            shift 2
            ;;
        --path)
            PATHS+=("$2")
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            if [[ -z $COMMAND ]]; then
                COMMAND="$1"
            else
                COMMAND_ARGS+=("$1")
            fi
            shift
            ;;
    esac
done

# After --, send remaining args to command
if [[ $# -gt 0 ]]; then
    COMMAND_ARGS+=("$@")
fi

git diff --name-status "$BASE" "${PATHS[@]}" |\
    awk '/^(A|M)/ { print $2 }' |\
    xargs "$COMMAND" "${COMMAND_ARGS[@]}"
