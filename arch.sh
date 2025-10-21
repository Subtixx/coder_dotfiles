#!/bin/bash

detect_package_manager() {
    PACKAGE_MANAGER="pacman"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Starting pacman package install session..."
    sudo pacman -Sy
}

os_stop_package_install() {
    log_info "Pacman package install session ended."
    sudo pacman -Sc --noconfirm
}

os_install_package() {
    local pkg="$1"
    log_info "Installing $pkg with pacman..."
    sudo pacman -S --noconfirm "$pkg"
}
os_install_packages() {
    sudo pacman -S --noconfirm --needed \
        zsh \
        git \
        curl \
        wget \
        tmux \
        vim \
        neovim \
        fzf \
        ripgrep \
        fd \
        bat \
        exa \
        htop \
        jq \
        unzip \
        tar \
        make \
        gcc \
        base-devel \
        openssh \
        gnupg \
        tree \
        ncdu \
        httpie
}
