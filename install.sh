#!/usr/bin/env bash
set -e

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

info()    { echo "${BLUE}ℹ️  $1${RESET}"; }
success() { echo "${GREEN}✅ $1${RESET}"; }
warn()    { echo "${YELLOW}⚠️  $1${RESET}"; }
error()   { echo "${RED}❌ $1${RESET}" >&2; exit 1; }

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
  info "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || error "Homebrew installation failed."
  success "Homebrew installed."
else
  success "Homebrew already installed."
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Oh My Zsh not found. Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    || error "Oh My Zsh installation failed."
  success "Oh My Zsh installed."
else
  success "Oh My Zsh already installed."
fi

# Install Zsh plugins
install_plugin() {
  local name=$1
  local repo=$2
  local target="$ZSH_CUSTOM/plugins/$name"

  if [ ! -d "$target" ]; then
    info "Installing $name..."
    git clone "$repo" "$target" \
      || warn "Failed to install $name."
    success "$name installed."
  else
    success "$name already installed."
  fi
}

install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
install_plugin "zsh-you-should-use" "https://github.com/MichaelAquilina/zsh-you-should-use"

# Install brew packages if Brewfile exists
BREWFILE="$HOME/Brewfile"
if [ -f "$BREWFILE" ]; then
  info "Installing packages from Brewfile..."
  brew bundle --file="$BREWFILE" || warn "Some brew bundle items may have failed."
  success "Brewfile packages installed."
else
  warn "No Brewfile found at $BREWFILE, skipping brew bundle."
fi

# Example: symlink dotfiles with stow if available
# if command -v stow >/dev/null 2>&1; then
#   info "Linking dotfiles with stow..."
#   stow zsh git nvim || warn "Some stow symlinks may have failed."
#   success "Dotfiles linked."
# else
#   warn "stow not installed, skipping symlink step."
# fi

success "All done! 🎉"
