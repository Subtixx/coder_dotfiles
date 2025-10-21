#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

detect_package_manager() {
    PACKAGE_MANAGER="pacman"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Starting pacman package install session..."
    run_with_sudo pacman -Sy
}

os_stop_package_install() {
    log_info "Pacman package install session ended."
    run_with_sudo pacman -Sc --noconfirm
}

os_is_package_installed() {
    local pkg="$1"
    pacman -Qi "$pkg" >/dev/null 2>&1
}

os_install_package() {
    local pkg="$1"
    log_info "Installing $pkg with pacman..."
    run_with_sudo pacman -S --noconfirm "$pkg"
}

os_install_packages() {
    local packages=("$@")
    run_with_sudo pacman -S --noconfirm --needed "${packages[@]}"
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
        base-devel
        openssh
        gnupg
        tree
        ncdu
        httpie
    )
    run_with_sudo pacman -S --noconfirm --needed "${packages[@]}"
}
