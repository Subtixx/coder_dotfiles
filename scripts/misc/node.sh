#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

nodejs_install() {
    log_section "Installing Node.js"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

    nvm install --lts
    nvm use --lts
    nvm alias default node

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