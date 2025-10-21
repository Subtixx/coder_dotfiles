#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

golang_install() {
    log_section "Installing Golang"

    log_info "Installing Golang..."
    asdf install golang latest

    log_info "Golang installed successfully"
    go version

    golang_install_global_packages
}

golang_install_global_packages() {
    log_section "Installing Global Go Packages"
    log_info "Installing global Go packages..."
    local global_packages=(
        golang.org/x/tools/gopls@latest
        github.com/go-delve/delve/cmd/dlv@latest
        golang.org/x/tools/cmd/goimports@latest
        github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        github.com/cosmtrek/air@latest
    )
    for package in "${global_packages[@]}"; do
        log_info "Installing Go package: $package"
        go install "$package"
    done
    log_info "Global Go packages installed"
}