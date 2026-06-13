#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_ROOT/agents"
TARGET_DIR="$HOME/.agents"

if [ -L "$TARGET_DIR" ]; then
  echo "~/.agents is already a symlink. Remove it first to reinstall."
  exit 1
fi

if [ -d "$TARGET_DIR" ]; then
  echo "~/.agents already exists as a directory."
  echo "Back it up and remove it first: mv ~/.agents ~/.agents.bak"
  exit 1
fi

ln -s "$SOURCE_DIR" "$TARGET_DIR"
echo "Linked $SOURCE_DIR -> $TARGET_DIR"
