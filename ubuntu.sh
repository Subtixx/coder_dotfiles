#!/bin/bash

detect_package_manager() {
    PACKAGE_MANAGER="apt"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Updating apt package index..."
    sudo apt-get update
}

os_stop_package_install() {
    log_info "Apt package install session ended."
    sudo rm -rf /var/cache/apt/archives/partial/*
}

os_install_package() {
    local pkg="$1"
    log_info "Installing $pkg with apt..."
    sudo apt-get install -y "$pkg"
}

os_install_packages() {
    sudo apt-get install -y \
        zsh \
        git \
        curl \
        wget \
        tmux \
        vim \
        neovim \
        fzf \
        ripgrep \
        fd-find \
        bat \
        htop \
        jq \
        unzip \
        tar \
        make \
        gcc \
        g++ \
        build-essential \
        openssh-client \
        gnupg \
        tree \
        ncdu \
        httpie \
        software-properties-common \
        apt-transport-https \
        ca-certificates
    # Create symlinks for Ubuntu/Debian naming differences
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
}
