#!/bin/bash

set -e

# Install additional tools
install_additional_tools() {
    log_section "Installing Additional Development Tools"
    if command -v docker >/dev/null 2>&1; then
        log_info "Docker detected, installing docker-compose..."
        install_package docker-compose
    fi
    log_info "Installing additional CLI tools..."

    detect_os
    local search_pkg
    if [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        search_pkg="the_silver_searcher"
    else
        search_pkg="silversearcher-ag"
    fi
    install_packages "$search_pkg" shellcheck direnv tldr

    log_info "Additional tools installed"
}
