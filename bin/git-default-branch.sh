#!/usr/bin/env bash

set -e -o pipefail

# Try to guess the "default" remote branch for the current Git project.

# Guess the target remote for the current branch
guess_remote() {
    # Adapted from https://apple.stackexchange.com/a/123408
    version() { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

    local git_version_text="$(git version)"
    local git_version="${git_version_text/#git version /}"
    local likely_remote=""

    if [ $(version "$git_version") -ge $(version "2.47.0") ]; then
        # Guess remote with is-base heuristic (only available in git 2.47 or newer)
        if likely_remote="$(git for-each-ref --format="%(is-base:${1}):%(refname:short)" 'refs/remotes/**/HEAD' | head -n1)"; then
            likely_remote="${likely_remote/#(${1}):/}"
        else
            likely_remote="origin"
        fi
    else
        # Try to get the remote from the parent branch
        # https://stackoverflow.com/a/42562318/910109
        local likely_parent="$(git show-branch | grep '*' | grep -v ${1} | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')"

        if ! likely_remote="$(git config --get "branch.${likely_parent}.remote")"; then
            likely_remote="origin"
        fi
    fi

    printf "%s" "$likely_remote"
}

current_branch="$(git branch --show-current)"

if [ -n "$current_branch" ]; then
    if ! current_remote="$(git config --get "branch.${current_branch}.remote")"; then
        # no configured remote, try to guess what it might be
        current_remote="$(guess_remote "$current_branch")"

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
