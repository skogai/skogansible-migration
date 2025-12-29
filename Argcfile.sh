#!/usr/bin/env bash

set -e

# @env SKOGAI_ANSIBLE_DIR=/home/skogix/.ansible

# @cmd Start a new worktree
# @arg name! The name of the worktree and branch
create() {
  wt switch -C "$SKOGAI_ANSIBLE_DIR" --create "${argc_name}"
  pwd
}

# @cmd Switch to a different worktree
# @arg name![`_choice_worktree_dirs`] The name of the worktree and branch
switch() {
  wt switch -C "$SKOGAI_ANSIBLE_DIR" "${argc_name}"
  pwd
}

# @cmd List the different worktrees
list() {
  _choice_worktree_dirs
}

_choice_worktree_dirs() {
  echo "@"
  echo "-"
  echo "^"
  echo "master"
  command ls "$SKOGAI_ANSIBLE_DIR/.worktrees"
}

eval "$(argc --argc-eval "$0" "$@")"
