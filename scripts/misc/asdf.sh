#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before asdf.sh"
    exit 1
fi

# Install asdf
asdf_install() {
    log_info "Installing asdf version manager..."

    if [[ -f "$HOME/bin/asdf" ]]; then
        log_warn "asdf already installed in \$HOME/bin. Skipping installation."
        return
    fi

    log_info "Downloading asdf binary tarball..."
    run_and_log mkdir -p "$HOME/bin"
    run_and_log curl -L https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz -o /tmp/asdf.tar.gz
    run_and_log tar -xzf /tmp/asdf.tar.gz -C "$HOME/bin" --strip-components=0
    run_and_log rm /tmp/asdf.tar.gz

    export PATH="$HOME/bin:$PATH"

    log_info "asdf installed successfully"
    asdf version
    asdf reshim

    asdf_install_plugins
}

asdf_install_plugins() {
    # Install asdf plugins
    log_info "Installing asdf plugins..."

    # Node.js
    if ! asdf plugin list | grep -q nodejs; then
        log_info "Installing asdf plugin for Node.js..."
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    fi

    # PHP
    if ! asdf plugin list | grep -q php; then
        log_info "Installing asdf plugin for PHP..."
        asdf plugin add php https://github.com/asdf-community/asdf-php.git
    fi

    # Golang
    if ! asdf plugin list | grep -q golang; then
        log_info "Installing asdf plugin for Golang..."
        asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    fi

    log_info "asdf plugins installed successfully"
}

# Ensure asdf plugins are present
asdf_ensure_plugin() {
    # Ensure $HOME/bin is in PATH for asdf command
    if [[ -z "$PATH" || ":$PATH:" != *":$HOME/bin:"* ]]; then
        export PATH="$HOME/bin:$PATH"
    fi

    local plugin="$1"
    local repo="$2"
    if ! asdf plugin list | grep -q "$plugin"; then
        log_info "Adding asdf plugin: $plugin"
        asdf plugin add "$plugin" "$repo"
    else
        log_info "asdf plugin $plugin already exists"
    fi
}
