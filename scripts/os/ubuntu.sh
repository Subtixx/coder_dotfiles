#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

detect_package_manager() {
    PACKAGE_MANAGER="apt"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Updating apt package index..."
    run_with_sudo apt-get update
}

os_stop_package_install() {
    log_info "Apt package install session ended."
    run_with_sudo rm -rf /var/cache/apt/archives/partial/*
}

os_is_package_installed() {
    local pkg="$1"
    dpkg -s "$pkg" >/dev/null 2>&1
}

os_install_package() {
    local pkg="$1"
    log_info "Installing $pkg with apt..."
    run_with_sudo apt-get install -y "$pkg"
}

os_install_packages() {
    local packages=("$@")
    run_with_sudo apt-get install -y "${packages[@]}"
}

os_install_system_packages() {
    local packages=(
        zsh
        git
        curl
        wget
        tmux
        vim
        neovim
        fzf
        ripgrep
        fd-find
        bat
        htop
        jq
        unzip
        tar
        make
        gcc
        g++
        build-essential
        openssh-client
        gnupg
        tree
        ncdu
        httpie
        software-properties-common
        apt-transport-https
        ca-certificates
    )
    run_with_sudo apt-get install -y "${packages[@]}"
    # Create symlinks for Ubuntu/Debian naming differences
    run_with_sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
    run_with_sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
}
