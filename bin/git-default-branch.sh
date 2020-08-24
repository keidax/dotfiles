#!/usr/bin/env bash

# Try to guess the "default" remote branch for the current Git project.

current_branch="$(git branch --show-current)"

if [ -n "$current_branch" ]; then
    current_remote="$(git config --get "branch.${current_branch}.remote")"
fi

if [ -z "$current_remote" ]; then
    current_remote="origin"
fi

remote_branch="$(git rev-parse --abbrev-ref "${current_remote}/HEAD")"

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

