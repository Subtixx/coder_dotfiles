#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before asdf.sh"
    exit 1
fi

zsh_install() {
    log_section "Installing Zsh"
    install_packages zsh
    log_info "Zsh installed successfully"
    zsh --version

    zsh_install_plugins
}

zsh_install_plugins() {
    log_info "Installing Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_warn "Oh My Zsh already installed, skipping..."
        return
    fi

    # Install Oh My Zsh non-interactively
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Install popular plugins
    log_info "Installing Oh My Zsh plugins..."

    # zsh-autosuggestions
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    # zsh-completions
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
        log_info "Installing zsh-completions plugin..."
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    fi

    # Powerlevel10k theme
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        log_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    log_info "Oh My Zsh installed successfully"
}

# Change default shell to zsh
zsh_change_shell() {
    log_info "Changing default shell to zsh..."

    if ! command -v zsh >/dev/null 2>&1; then
        log_error "zsh is not installed, cannot change shell."
        return
    fi

    if [[ "$SHELL" == "$(which zsh)" ]]; then
        log_warn "Shell is already zsh, skipping..."
        return
    fi

    chsh -s "$(which zsh)" || log_warn "Could not change shell automatically. Run: chsh -s \$(which zsh)"

    log_info "Default shell changed to zsh"
}
