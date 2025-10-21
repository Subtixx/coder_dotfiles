#!/bin/bash

detect_package_manager() {
    PACKAGE_MANAGER="apk"
    log_info "Using package manager: $PACKAGE_MANAGER"
}

os_start_package_install() {
    log_info "Starting apk package install session..."
    sudo apk update
}

os_stop_package_install() {
    log_info "Apk package install session ended."
    # No specific cleanup needed for apk
}

os_install_packages() {
    sudo apk add --no-cache \
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
        openssh \
        gnupg \
        tree \
        ncdu \
        httpie
}
