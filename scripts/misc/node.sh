#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

nodejs_install() {
    log_section "Installing Node.js"
    if command -v nvm >/dev/null 2>&1; then
        local node_version
        node_version=$(curl -s https://nodejs.org/dist/index.tab | awk 'NR>1 && $1 ~ /^v[0-9]+\.[0-9]+\.[0-9]+$/ {print substr($1,2)}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -1)
        if [[ -z "$node_version" ]]; then
            log_error "Could not determine a stable Node.js version to install."
            exit 1
        fi
        log_info "Installing Node.js $node_version with nvm..."
        nvm install "$node_version"
        nvm alias default "$node_version"
    else
        asdf_ensure_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git
        local node_version
        node_version=$(asdf_get_latest_stable nodejs)
        if [[ -z "$node_version" ]]; then
            log_error "Could not determine a stable Node.js version to install."
            exit 1
        fi
        log_info "Installing Node.js $node_version with asdf..."
        asdf install nodejs "$node_version"
        asdf global nodejs "$node_version"
    fi
    log_info "Node.js installed successfully"
    node -v
    npm -v
    nodejs_install_global_packages
}

nodejs_install_global_packages() {
    log_section "Installing Global npm Packages"
    log_info "Installing global npm packages..."
    local global_packages=(
        yarn
        pnpm
        typescript
        ts-node
        @vue/cli
        @angular/cli
        create-react-app
        vite
        eslint
        prettier
        nodemon
        pm2
        http-server
        serve
    )
    npm install -g "${global_packages[@]}"
    log_info "Global npm packages installed"
}