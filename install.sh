#!/usr/bin/env bash
# Dotfiles installer — symlinks configs into place via GNU stow.
# Safe to re-run (idempotent). Cross-platform: macOS + Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# 1. Homebrew ---------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make brew available in this session
for p in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [ -x "$p" ] && eval "$("$p" shellenv)" && break
done
if ! command -v brew >/dev/null 2>&1; then
  echo "Error: Homebrew is not on PATH after install. Add it manually and re-run." >&2
  echo "  See the 'Next steps' printed by the Homebrew installer above." >&2
  exit 1
fi

# 2. CLI tools from the Brewfile -------------------------------------------
info "Installing CLI tools (brew bundle)..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. oh-my-zsh + external zsh plugins --------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone_plugin() {
  local name="$1" url="$2" dest="$ZSH_CUSTOM/plugins/$1"
  if [ ! -d "$dest" ]; then
    info "Cloning zsh plugin: $name"
    git clone --depth=1 "$url" "$dest"
  fi
}
clone_plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

# 4. Symlink dotfiles via stow ---------------------------------------------
# Stow aborts if a target already exists as a real file (e.g. a distro's stock
# ~/.bashrc). Back any such files up first so stow can take over cleanly.
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
backup_conflicts() {
  local pkg="$1" target="$2" rel dest
  while IFS= read -r rel; do
    dest="$target/$rel"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      info "Backing up existing $dest"
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$dest" "$BACKUP_DIR/$rel"
    fi
  done < <(cd "$pkg" && find . \( -type f -o -type l \) | sed 's|^\./||')
}

info "Symlinking dotfiles with stow..."
mkdir -p "$HOME/.config"
cd "$DOTFILES_DIR"
backup_conflicts home "$HOME"
backup_conflicts config "$HOME/.config"
[ -d "$BACKUP_DIR" ] && info "Pre-existing files backed up to $BACKUP_DIR"
stow --target="$HOME"         --restow home
stow --target="$HOME/.config" --restow config

info "Done. Restart your shell (or 'exec zsh') to load the new config."
echo "Remaining manual steps are in the README (secrets, AI CLI auth, GUI apps)."
