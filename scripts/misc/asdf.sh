#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before asdf.sh"
    exit 1
fi

# Install asdf
asdf_install() {
    log_info "Installing asdf version manager..."

    if [[ -d "$HOME/.asdf" ]]; then
        log_warn "asdf already installed, updating..."
        cd "$HOME/.asdf"
        git pull
        cd -
    else
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.18.0
    fi

    # Source asdf to use it immediately
    . "$HOME/.asdf/asdf.sh"
    log_info "asdf installed successfully"
    asdf version
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

asdf_get_latest_stable() {
    local plugin="$1"
    local extra_regex="$2"
    local list
    list=$(asdf list-all "$plugin" 2>/dev/null || true)
    if [[ -z "$list" ]]; then
        echo ""
        return
    fi
    if [[ -n "$extra_regex" ]]; then
        echo "$list" | grep -E "$extra_regex" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 || true
    else
        echo "$list" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 || true
    fi
}

# Check asdf and source
asdf_check() {
    if [[ ! -d "$HOME/.asdf" ]]; then
        log_error "asdf is not installed. Please run install.sh first."
        exit 1
    fi
    log_info "Sourcing asdf..."
    . "$HOME/.asdf/asdf.sh"
    log_info "asdf sourced successfully"
}

# Ensure asdf plugins are present
asdf_ensure_plugin() {
    local plugin="$1"
    local repo="$2"
    if ! asdf plugin list | grep -q "$plugin"; then
        log_info "Adding asdf plugin: $plugin"
        asdf plugin add "$plugin" "$repo"
    else
        log_info "asdf plugin $plugin already exists"
    fi
}
