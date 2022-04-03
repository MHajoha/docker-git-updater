#!/bin/bash

# Variables:
# SCHEDULE (optional)
# GIT_REMOTE
# GIT_BRANCH (optional)
# CLONE_DIR (optional, default /repo)
# GIT_USERNAME (optional)
# GIT_PASSWORD (optional)
# GIT_PASSWORD_PATH (optional)

set -o nounset -o errexit

if [[ -n "${GIT_PASSWORD:-}" ]]; then
  if [[ -z "${GIT_PASSWORD_PATH:-}" ]]; then
    export GIT_PASSWORD_PATH="$(mktemp)"
    chmod go-rwx "$GIT_PASSWORD_PATH"
  fi

  echo -n "$GIT_PASSWORD" >"$GIT_PASSWORD_PATH"
fi

git config --global init.defaultBranch main
if [[ -n "${GIT_PASSWORD_PATH:-}" ]]; then
  git config --global credential.helper "/cred-helper.sh '$GIT_USERNAME' '$GIT_PASSWORD_PATH'"
elif [[ -n "${GIT_USERNAME:-}" ]]; then
  git config --global credential.helper "/cred-helper.sh '$GIT_USERNAME'"
fi

if [[ -z "${CLONE_DIR:-}" ]]; then
  CLONE_DIR="/repo"
fi

/update.sh "$CLONE_DIR" "$GIT_REMOTE" "${GIT_BRANCH:-}"

if [[ -n "${SCHEDULE:-}" ]]; then
  echo "$SCHEDULE /update.sh '$CLONE_DIR' '$GIT_REMOTE' '${GIT_BRANCH:-}'" >/var/spool/cron/crontabs/root

  exec crond -fL /dev/stderr
fi
