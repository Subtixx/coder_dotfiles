#!/bin/bash

# Dotfiles installation script for development environments
# Supports: Arch Linux, Ubuntu
# Author: Subtixx
# Description: Installs and configures zsh, oh-my-zsh, asdf, tmux, and development tools


set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"
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
            ;;
        *)
            log_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac

    log_info "System packages installed successfully"
}

# Install Oh My Zsh
install_oh_my_zsh() {
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
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi

    # zsh-completions
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    fi

    # Powerlevel10k theme
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    fi

    log_info "Oh My Zsh installed successfully"
}

# Install asdf
install_asdf() {
    log_info "Installing asdf version manager..."

    if [[ -d "$HOME/.asdf" ]]; then
        log_warn "asdf already installed, updating..."
        cd "$HOME/.asdf"
        git pull
        cd -
    else
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    fi

    # Source asdf to use it immediately
    . "$HOME/.asdf/asdf.sh"

    # Install asdf plugins
    log_info "Installing asdf plugins..."

    # Node.js
    if ! asdf plugin list | grep -q nodejs; then
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    fi

    # PHP
    if ! asdf plugin list | grep -q php; then
        asdf plugin add php https://github.com/asdf-community/asdf-php.git
    fi

    # Golang
    if ! asdf plugin list | grep -q golang; then
        asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    fi

    # Composer
    if ! asdf plugin list | grep -q composer; then
        asdf plugin add composer https://github.com/asdf-community/asdf-composer.git
    fi

    # Yarn
    if ! asdf plugin list | grep -q yarn; then
        asdf plugin add yarn https://github.com/twuni/asdf-yarn.git
    fi

    log_info "asdf installed successfully"
}

# Install tmux plugin manager
install_tmux_plugins() {
    log_info "Installing tmux plugin manager (TPM)..."

    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        log_warn "TPM already installed, skipping..."
        return
    fi

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    log_info "TPM installed successfully"
}

# Copy dotfiles
copy_dotfiles() {
    log_info "Copying dotfiles..."

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Backup existing files
    for file in .zshrc .tmux.conf .gitconfig .asdfrc; do
        if [[ -f "$HOME/$file" ]]; then
            log_warn "Backing up existing $file to $file.backup"
            cp "$HOME/$file" "$HOME/$file.backup"
        fi
    done

    # Copy dotfiles from repository
    for file in .zshrc .tmux.conf .gitconfig .asdfrc; do
        if [[ -f "$SCRIPT_DIR/$file" ]]; then
            cp "$SCRIPT_DIR/$file" "$HOME/"
            log_info "Copied $file"
        fi
    done

    # Create directories if needed
    mkdir -p "$HOME/.config"

    log_info "Dotfiles copied successfully"
}

# Change default shell to zsh
change_shell() {
    log_info "Changing default shell to zsh..."

    if [[ "$SHELL" == "$(which zsh)" ]]; then
        log_warn "Shell is already zsh, skipping..."
        return
    fi

    if command -v zsh >/dev/null 2>&1; then
        chsh -s "$(which zsh)" || log_warn "Could not change shell automatically. Run: chsh -s \$(which zsh)"
    fi

    log_info "Default shell changed to zsh"
}

# Main installation flow
main() {
    log_info "Starting dotfiles installation..."
    log_info "================================================"

    common_detect_os
    source_os_script
    start_package_install
    install_packages
    stop_package_install
    install_oh_my_zsh
    install_asdf
    install_tmux_plugins
    copy_dotfiles
    install_nerd_fonts
    change_shell

    log_info "================================================"
    log_info "Installation complete!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Restart your terminal or run: source ~/.zshrc"
    log_info "2. Install language versions with asdf:"
    log_info "   - Node.js: asdf install nodejs latest && asdf global nodejs latest"
    log_info "   - PHP: asdf install php latest && asdf global php latest"
    log_info "   - Golang: asdf install golang latest && asdf global golang latest"
    log_info "3. Install tmux plugins: Press prefix + I (default: Ctrl+b then I)"
    log_info "4. Configure Powerlevel10k: Run 'p10k configure' (if using)"
    log_info ""
    log_info "Enjoy your development environment! 🚀"
}

# Run main installation
main "$@"
