#!/bin/bash
set -o nounset -o errexit

echo "username=$1"
if [[ -n "${2:-}" ]]; then
  echo "password=$(cat "$2")"
fi
