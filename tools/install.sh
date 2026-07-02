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

# Link opencode agent definitions (e.g. conductor) so opencode discovers them.
AGENT_SOURCE_DIR="$SOURCE_DIR/agent"
AGENT_TARGET_DIR="$HOME/.config/opencode/agent"

if [ -L "$AGENT_TARGET_DIR" ]; then
  echo "~/.config/opencode/agent is already a symlink. Remove it first to reinstall."
elif [ -d "$AGENT_TARGET_DIR" ]; then
  echo "~/.config/opencode/agent already exists as a directory."
  echo "Back it up and remove it first: mv ~/.config/opencode/agent ~/.config/opencode/agent.bak"
else
  mkdir -p "$HOME/.config/opencode"
  ln -s "$AGENT_SOURCE_DIR" "$AGENT_TARGET_DIR"
  echo "Linked $AGENT_SOURCE_DIR -> $AGENT_TARGET_DIR"
fi

# Link opencode skills so the `skill` tool discovers them.
SKILLS_SOURCE_DIR="$SOURCE_DIR/skills"
SKILLS_TARGET_DIR="$HOME/.config/opencode/skills"

if [ -L "$SKILLS_TARGET_DIR" ]; then
  echo "~/.config/opencode/skills is already a symlink. Remove it first to reinstall."
elif [ -d "$SKILLS_TARGET_DIR" ]; then
  echo "~/.config/opencode/skills already exists as a directory."
  echo "Back it up and remove it first: mv ~/.config/opencode/skills ~/.config/opencode/skills.bak"
else
  mkdir -p "$HOME/.config/opencode"
  ln -s "$SKILLS_SOURCE_DIR" "$SKILLS_TARGET_DIR"
  echo "Linked $SKILLS_SOURCE_DIR -> $SKILLS_TARGET_DIR"
fi
