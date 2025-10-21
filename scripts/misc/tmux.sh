#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before asdf.sh"
    exit 1
fi

tmux_install() {
    # install tmux
    log_section "Installing tmux"
    install_packages tmux
    log_info "tmux installed successfully"
    tmux -V

    log_info "Installing tmux plugin manager (TPM)..."

    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_warn "TPM already installed, skipping..."
        return
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    log_info "TPM installed successfully"
}

tmux_install_plugins() {
    log_info "Installing tmux plugins using TPM..."

    # Install tmux plugins non-interactively
    ~/.tmux/plugins/tpm/bin/install_plugins

    log_info "tmux plugins installed successfully"
}