#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

detect_package_manager() {
    PACKAGE_MANAGER="apk"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Starting apk package install session..."
    run_with_sudo apk update
}

os_stop_package_install() {
    log_info "Apk package install session ended."
    # No specific cleanup needed for apk
}

os_is_package_installed() {
    local package="$1"
    if apk info -e "$package" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

os_install_package() {
    local package="$1"
    run_with_sudo apk add --no-cache "$package"
}

os_install_packages() {
    local packages=("$@")
    run_with_sudo apk add --no-cache "${packages[@]}"
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
        fd
        bat
        exa
        htop
        jq
        unzip
        tar
        make
        gcc
        openssh
        gnupg
        tree
        ncdu
        httpie
    )
    run_with_sudo apk add --no-cache "${packages[@]}"
}