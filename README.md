# I3-dots

This repository contains my i3-related dotfiles. Everything to be linked lives under .config/ (fish, i3, kitty, picom, rofi, etc.). The installer creates symlinks in your real ~/.config and backs up any existing entries.

## Requirements

- git
- bash
- i3
- feh
- rofi
- kitty
- fish
- picom
- neovim
- flameshot
- starship

## Quick install (one command)

This clones the repo into ~/.local/share/I3-dots (or $XDG_DATA_HOME/I3-dots if set), updates it if already present, then runs the linker.

```sh
bash -c 'set -e
REPO="https://github.com/DavidGailleton/I3-dots.git"
CLONE_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}"
DIR="$CLONE_ROOT/I3-dots"
mkdir -p "$CLONE_ROOT"
if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only
else
  git clone "$REPO" "$DIR"
fi
bash "$DIR/link_configs.sh"'
```

## Manual install


Clone the repo (recommended location):

```sh
git clone https://github.com/DavidGailleton/I3-dots.git "${XDG_DATA_HOME:-$HOME/.local/share}/I3-dots"
```

Run the linker from the repo root (no need to chmod if you call bash directly):

```sh
bash "${XDG_DATA_HOME:-$HOME/.local/share}/I3-dots/link_configs.sh"
```

## What the installer does

Creates symlinks from repo/.config/<name> to ~/.config/<name>.
Backs up existing items in ~/.config as <name>.backup.YYYYMMDDHHMMSS if they are not already correct symlinks.
Safe to re-run: it will refresh links and won’t duplicate backups unnecessarily.

## Update to latest

Pull changes and re-link:

```sh
git -C "${XDG_DATA_HOME:-$HOME/.local/share}/I3-dots" pull --ff-only
bash "${XDG_DATA_HOME:-$HOME/.local/share}/I3-dots/link_configs.sh"
```

## Uninstall (manual)

Remove the symlinks created in ~/.config (they point into ~/.local/share/I3-dots/.config).

Optionally restore your backups (files ending with .backup.YYYYMMDDHHMMSS).

Optionally remove the clone:

```sh
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/I3-dots"
```

## Notes

The script uses $XDG_CONFIG_HOME and $XDG_DATA_HOME if set, otherwise defaults to /.config and /.local/share.
