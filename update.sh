#!/bin/bash
set -o nounset -o errexit

readonly CLONE_DIR="$1"
readonly GIT_REMOTE="$2"
[[ -n "${3:-}" ]] && readonly GIT_BRANCH="$3"

mkdir -p "$CLONE_DIR"
cd "$CLONE_DIR"

if [[ ! -d "$CLONE_DIR/.git" ]]; then
  git init
  git remote add origin "$GIT_REMOTE"
fi

git fetch -a

if [[ -n "${GIT_BRANCH:-}" ]]; then
  git switch "origin/$GIT_BRANCH"
else
  git remote set-head origin -a
  git switch --detach origin/HEAD
fi
