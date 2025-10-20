
#!/bin/bash

#set -e

. "$(dirname "$0")/common.sh"

FZF_ROOT="$HOME/.fzf"
FZF_VERSION="master"

if [ ! -d "$FZF_ROOT" ]; then
  info "Cloning fzf repository to $FZF_ROOT"
  git clone --depth 1 --branch "$FZF_VERSION" https://github.com/junegunn/fzf.git "$FZF_ROOT"
  success "fzf cloned successfully."
else
  info "fzf already present at $FZF_ROOT"
fi

# Install fzf binaries
info "Installing fzf binaries."
"$FZF_ROOT"/install --bin && success "fzf binaries installed." || error "Failed to install fzf binaries."
