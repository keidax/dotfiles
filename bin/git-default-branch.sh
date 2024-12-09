#!/usr/bin/env bash

set -e -o pipefail

# Try to guess the "default" remote branch for the current Git project.

current_branch="$(git branch --show-current)"

if [ -n "$current_branch" ]; then
    current_remote="$(git config --get "branch.${current_branch}.remote")"
fi

if [ -z "$current_remote" ]; then
    current_remote="origin"
fi

if ! remote_branch="$(git rev-parse --abbrev-ref "${current_remote}/HEAD")"; then
    printf "\e[31mCould not parse the default remote branch.\nYou might want to run \e[33;1mgit remote set-head %s -a\e[0m\n" "$current_remote" 1>&2
    exit 1
fi

if [ -n "$remote_branch" ]; then
    branch="$(echo "$remote_branch" | sed -e "s/${current_remote}\///")"
fi

if [ -z "$branch" ]; then
    branch="master"
fi

if [ "$1" = "--with-remote" ]; then
    echo "${current_remote}/${branch}"
else
    echo "${branch}"
fi

