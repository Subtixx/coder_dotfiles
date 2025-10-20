#!/bin/bash

# Quick start script for coder_dotfiles
# Usage: curl -fsSL https://raw.githubusercontent.com/Subtixx/coder_dotfiles/main/quickstart.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

main() {
    log_section "Coder Dotfiles Quick Start"
    
    # Check if git is installed
    if ! command -v git >/dev/null 2>&1; then
        log_error "Git is not installed. Please install git first."
        exit 1
    fi
    
    # Clone repository
    DOTFILES_DIR="$HOME/coder_dotfiles"
    
    if [ -d "$DOTFILES_DIR" ]; then
        log_info "Dotfiles directory already exists. Updating..."
        cd "$DOTFILES_DIR"
        git pull
    else
        log_info "Cloning dotfiles repository..."
        git clone https://github.com/Subtixx/coder_dotfiles.git "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi
    
    # Run installation
    log_info "Running installation script..."
    chmod +x install.sh
    ./install.sh
    
    log_section "Installation Complete!"
    log_info "To install development tools, run:"
    log_info "  cd $DOTFILES_DIR && ./install-dev-tools.sh"
    log_info ""
    log_info "To apply changes, restart your terminal or run:"
    log_info "  source ~/.zshrc"
}

main "$@"
