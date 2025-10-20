#!/bin/bash

#set -e

. "$(dirname "$0")/common.sh"

ASDF_ROOT="$HOME/.asdf"
ASDF_REPO="https://github.com/asdf-vm/asdf.git"
ASDF_VERSION="v0.14.0"

# Install dependencies
info "Installing dependencies for asdf."
sudo apt-get update && sudo apt-get install -y git curl build-essential && success "Dependencies installed." || error "Failed to install dependencies."

# Install asdf
if [ ! -d "$ASDF_ROOT" ]; then
  info "Cloning asdf to $ASDF_ROOT"
  git clone "$ASDF_REPO" "$ASDF_ROOT" --branch "$ASDF_VERSION" && success "asdf cloned successfully." || error "Failed to clone asdf."
else
  info "asdf already present at $ASDF_ROOT"
fi

. "$ASDF_ROOT/asdf.sh"

# Add plugins and install versions for Laravel, PHP, Composer
# PHP
info "Adding asdf plugin: php"
asdf plugin add php https://github.com/asdf-community/asdf-php.git && success "asdf php plugin added." || warn "asdf php plugin may already exist."
# Composer
info "Adding asdf plugin: composer"
asdf plugin add composer https://github.com/asdf-community/asdf-composer.git && success "asdf composer plugin added." || warn "asdf composer plugin may already exist."
# Node.js (required for Laravel Mix and frontend tooling)
info "Adding asdf plugin: nodejs"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && success "asdf nodejs plugin added." || warn "asdf nodejs plugin may already exist."
# You can now install specific versions, e.g.:
# asdf install php latest
# asdf global php latest
# asdf install composer latest
# asdf global composer latest
# asdf install nodejs lts
# asdf global nodejs lts
