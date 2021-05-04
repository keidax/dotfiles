#!/bin/sh
#
# Output variable definitions that represent the current git status. Suitable
# for sourcing with `eval`.
#
# Output:
#   git_present
#       0 if the current directory is not a git repository, non-zero otherwise.
#       If 0, no other variables are emitted.
#
#   git_branch_name
#       Current branch name or "(detached)"
#
#   git_ahead
#       How many commits this branch is ahead of its upstream. 0 if no upstream
#       branch is configured.
#
#   git_behind
#       How many commits this branch is behind its upstream. 0 if no upstream
#       branch is configured.
#
#   git_untracked
#       Number of untracked files.
#
#   git_unstaged
#       Number of files with unstaged changes.
#
#   git_staged
#       Number of files with staged changes.
#
#   git_stashed
#       Number of stashed commits.

_is_git() {
    git rev-parse --is-inside-work-tree 2>/dev/null 1>&2
}

_is_git || {
    echo "git_present=0"
    exit 0
}

git status --porcelain=v2 --branch | awk "
# We need to escape user-supplied strings to be 'eval'ed. The simplest way is
# to surround the string in single quotes, and replace any single quotes in the
# string with '\'' (that is, end the single-quoted string, add a literal single
# quote, start a new single-quoted string).
function shellescape(s) {
    gsub(/'/, \"'\\\\''\", s)
    return sprintf(\"'%s'\", s)
}
"'
BEGIN {
    git_ahead = 0
    git_behind = 0
    git_untracked = 0
    git_unstaged = 0
    git_staged = 0
    git_branch_name = ""
}
$2 ~ /branch\.head/ {
    git_branch_name = $3
}
$2 ~ /branch\.ab/ {
    sub(/\+/, "", $3)
    sub(/-/, "", $4)
    git_ahead = $3
    git_behind = $4
}
$1 ~ /\?/ {
    git_untracked += 1
}
$1 ~ /[12]/ && $2 ~ /.[MD]/ {
    git_unstaged += 1
}
$1 ~ /[12]/ && $2 ~/[ACDRM]./ {
    git_staged += 1
}
END {
    print "git_present=1"
    print "git_branch_name="shellescape(git_branch_name)
    print "git_ahead="git_ahead
    print "git_behind="git_behind
    print "git_untracked="git_untracked
    print "git_unstaged="git_unstaged
    print "git_staged="git_staged
}
'
# Git's porcelain status doesn't include stashes
git_stash_file="$(git rev-parse --git-dir)/logs/refs/stash"
if [ -s "$git_stash_file" ]; then
    echo "git_stashed=$(awk 'END{print NR}' < "$git_stash_file")"
else
    echo "git_stashed=0"
fi
unset git_stash_file
