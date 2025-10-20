#!/bin/bash

#set -e

. "$(dirname "$0")/common.sh"

ZSH_ROOT="$HOME/.oh-my-zsh"
ZSH_VERSION="master"

# Install oh-my-zsh
if [ ! -d "$ZSH_ROOT" ]; then
  info "Cloning oh-my-zsh to $ZSH_ROOT"
  git clone --depth 1 --branch "$ZSH_VERSION" https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_ROOT" && success "oh-my-zsh cloned successfully." || error "Failed to clone oh-my-zsh."
else
  info "oh-my-zsh already present at $ZSH_ROOT"
fi

# Install plugins (edit as needed)

# PHP, Laravel, and development plugins
# zsh-autosuggestions: command suggestions as you type
if [ ! -d "$ZSH_ROOT/custom/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions plugin."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_ROOT/custom/plugins/zsh-autosuggestions" && success "zsh-autosuggestions installed." || error "Failed to install zsh-autosuggestions."
else
  info "zsh-autosuggestions already installed."
fi
# zsh-syntax-highlighting: syntax highlighting for the shell
if [ ! -d "$ZSH_ROOT/custom/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting plugin."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_ROOT/custom/plugins/zsh-syntax-highlighting" && success "zsh-syntax-highlighting installed." || error "Failed to install zsh-syntax-highlighting."
else
  info "zsh-syntax-highlighting already installed."
fi
# zsh-completions: additional completion definitions
if [ ! -d "$ZSH_ROOT/custom/plugins/zsh-completions" ]; then
  info "Installing zsh-completions plugin."
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_ROOT/custom/plugins/zsh-completions" && success "zsh-completions installed." || error "Failed to install zsh-completions."
else
  info "zsh-completions already installed."
fi
# zsh-history-substring-search: search history by substring
if [ ! -d "$ZSH_ROOT/custom/plugins/zsh-history-substring-search" ]; then
  info "Installing zsh-history-substring-search plugin."
  git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_ROOT/custom/plugins/zsh-history-substring-search" && success "zsh-history-substring-search installed." || error "Failed to install zsh-history-substring-search."
else
  info "zsh-history-substring-search already installed."
fi
# zsh-better-npm-completion: better npm/yarn completion (useful for JS dev)
if [ ! -d "$ZSH_ROOT/custom/plugins/zsh-better-npm-completion" ]; then
  info "Installing zsh-better-npm-completion plugin."
  git clone https://github.com/lukechilds/zsh-better-npm-completion "$ZSH_ROOT/custom/plugins/zsh-better-npm-completion" && success "zsh-better-npm-completion installed." || error "Failed to install zsh-better-npm-completion."
else
  info "zsh-better-npm-completion already installed."
fi

# Install powerlevel10k theme
if [ ! -d "$ZSH_ROOT/custom/themes/powerlevel10k" ]; then
  info "Installing powerlevel10k theme."
  git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$ZSH_ROOT/custom/themes/powerlevel10k" && success "powerlevel10k installed." || error "Failed to install powerlevel10k."
else
  info "powerlevel10k already installed."
fi

# Enable oh-my-zsh plugins for PHP, Laravel, and development
# These plugins are included with oh-my-zsh, just add them to the plugins list in .zshrc
PLUGINS_LIST="laravel alias-finder zoxide vault qodana pre-commit command-not-found composer docker-compose docker eza fzf git-flow gitfast nvm npm sudo systemadmin tmux ubuntu zsh-interactive-cd zsh-navigation-tools zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search zsh-better-npm-completion"

# Update .zshrc plugins line if present, otherwise append
ZSHRC="$HOME/.zshrc"
if grep -q '^plugins=' "$ZSHRC"; then
  sed -i "s/^plugins=.*/plugins=($PLUGINS_LIST)/" "$ZSHRC"
else
  echo "\nplugins=($PLUGINS_LIST)" >> "$ZSHRC"
fi

# Set login shell to zsh
chsh -s /bin/zsh "$USER"
