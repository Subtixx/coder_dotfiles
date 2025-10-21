#!/bin/bash

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/common.sh"

for script in "$SCRIPT_DIR/misc/"*.sh; do
    . "$script"
done

install_nerd_font() {
    local font="$1"

    log_info "Installing Nerd Font $font..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip"
    log_info "Downloading $font..."
    run_and_log curl -L -o "$font_dir/$font.zip" "$font_url"
    log_info "Extracting $font..."
    run_and_log unzip -o "$font_dir/$font.zip" -d "$font_dir/"
    rm "$font_dir/$font.zip"
}

install_nerd_fonts() {
    log_info "Installing Nerd Fonts..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    local fonts=(
        "FiraCode"
        "JetBrainsMono"
    )

    for font in "${fonts[@]}"; do
        local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip"
        log_info "Downloading $font..."
        run_and_log curl -L -o "$font_dir/$font.zip" "$url"
        log_info "Extracting $font..."
        run_and_log unzip -o "$font_dir/$font.zip" -d "$font_dir/"
        rm "$font_dir/$font.zip"
    done

    log_info "Nerd Fonts installed successfully"
}

# Copy dotfiles
copy_dotfiles() {
    log_info "Copying dotfiles..."

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Return early if config/ does not exist
    if [[ ! -d "$SCRIPT_DIR/config" ]]; then
        log_warn "No config directory found, skipping dotfiles copy."
        return
    fi

    log_info "Copying config files to ~/.config/ ..."
    mkdir -p "$HOME/.config"
    shopt -s dotglob
    for item in "$SCRIPT_DIR/config/"*; do
        baseitem="$(basename "$item")"
        target="$HOME/.config/$baseitem"
        if [[ -e "$target" ]]; then
            log_warn "Backing up existing config $baseitem to $baseitem.backup"
            mv "$target" "$target.backup"
        fi
        if [[ -d "$item" ]]; then
            cp -r "$item" "$HOME/.config/"
        else
            cp "$item" "$HOME/.config/"
        fi
        log_info "Copied config $baseitem"
    done
    shopt -u dotglob
    log_info "Config files copied"
    log_info "Dotfiles copied successfully"
}

# Main installation flow
main() {
    log_info "Starting dotfiles installation..."
    log_info "================================================"

    detect_os
    source_os_script
    start_package_install
    install_system_packages

    zsh_install
    asdf_install
    nodejs_install
    tmux_install
    php_install
    golang_install
    copy_dotfiles
    install_nerd_fonts
    zsh_change_shell

    stop_package_install

    log_info "================================================"
    log_info "Installation complete!"
    log_info ""
    log_info "Please restart your terminal or run: source ~/.zshrc for all the changes to take effect."
    log_info "You can now set up Powerlevel10k: Run 'p10k configure' in your terminal to do so."
    log_info "Be sure to refresh font cache: Run 'fc-cache -fv' to update font cache."
    log_info ""
    log_info "That's it!"
    log_info ""
    log_info "Enjoy your development environment! 🚀"
}

# Run main installation
main "$@"
