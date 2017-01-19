#!/usr/bin/env bash

# Adapted from http://haacked.com/archive/2014/07/28/github-flow-aliases/

local_merged_branches=$(git branch --merged "${1-master}" | grep -v " ${1-master}")
echo "$(tput setaf 1)These local branches will be deleted:"
echo "$(tput bold)$local_merged_branches"
while true; do
    read -e -r -p "$(tput setaf 1)Do you want to continue? [y/N]$(tput sgr0) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done

echo "$local_merged_branches" | xargs git branch -d
