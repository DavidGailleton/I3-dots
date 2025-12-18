#!/usr/bin/env bash

set -euo pipefail

# Where to place links (defaults to ~/.config or $XDG_CONFIG_HOME)
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Resolve repo root from this script's location
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$SCRIPT_DIR"
SRC_DIR="$REPO_ROOT/.config"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Error: $SRC_DIR not found. Make sure this repo contains a .config directory." >&2
  exit 1
fi

mkdir -p "$TARGET_CONFIG_DIR"

timestamp() { date +%Y%m%d%H%M%S; }

link_one() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [[ "$cur" == "$src" ]]; then
      echo "OK  $dst -> $src (already correct)"
      return
    else
      echo "RM  $dst (was symlink to $cur)"
      rm -f "$dst"
    fi
  elif [[ -e "$dst" ]]; then
    local bak="${dst}.backup.$(timestamp)"
    echo "MV  $dst -> $bak (backing up existing file/dir)"
    mv "$dst" "$bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "LN  $dst -> $src"
}

shopt -s dotglob nullglob

echo "Linking entries from $SRC_DIR into $TARGET_CONFIG_DIR ..."

for src in "$SRC_DIR"/*; do
  [[ -e "$src" ]] || continue
  name="$(basename "$src")"
  # Skip VCS dirs if any
  [[ "$name" == ".git" ]] && continue
  dst="$TARGET_CONFIG_DIR/$name"
  link_one "$src" "$dst"
done

echo "Done."
