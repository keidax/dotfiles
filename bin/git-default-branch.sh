#!/usr/bin/env bash

set -e -o pipefail

# Try to guess the "default" remote branch for the current Git project.

current_branch="$(git branch --show-current)"

if [ -n "$current_branch" ]; then
    if ! current_remote="$(git config --get "branch.${current_branch}.remote")"; then
        # no configured remote, try to guess what it might be with is-base heuristic
        likely_remote="$(git for-each-ref --format="%(is-base:${current_branch}):%(refname:short)" 'refs/remotes/**/HEAD' | head -n1)"

        current_remote="${likely_remote/#(${current_branch}):/}"

        printf "\e[33mNo upstream branch configured, assuming \e[31;1m%s\e[22;33m is the desired remote.\n\e[0mRun \e[33;1mgit branch --set-upstream <remote>\e[0m to override this.\e[0m\n" "$current_remote" 1>&2
    fi
fi

if [ -z "$current_remote" ]; then
    current_remote="origin"
fi

if ! remote_branch="$(git rev-parse --abbrev-ref "${current_remote}/HEAD")"; then
    printf "\e[31mCould not parse the default remote branch.\nYou might want to run \e[33;1mgit remote set-head %s -a\e[0m\n" "$current_remote" 1>&2
    exit 1
fi

if [ "$1" = "--remote" ]; then
    # Output the remote form of the default branch, e.g. origin/main
    echo "${remote_branch}"
    exit 0
fi

if ! remote_and_local="$(
    git for-each-ref --format='%(upstream:lstrip=2):%(refname:short)' refs/heads/ |
        grep "${remote_branch}:" --max-count=1
)"; then
    printf "\e[31mCould not find a local branch with %s as an upstream\e[0m\n" "${remote_branch}" 1>&2
    exit 1
fi

local_branch="${remote_and_local/#${remote_branch}:/}"

if [ -z "$local_branch" ]; then
    if git rev-parse --verify main &>/dev/null; then
        local_branch="main"
    else
        local_branch="master"
    fi
fi

echo "${local_branch}"
