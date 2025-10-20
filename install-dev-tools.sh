#!/bin/bash

# Development tools installation script
# Installs language versions and development tools using asdf

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
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

# Check if asdf is installed
check_asdf() {
    if [[ ! -d "$HOME/.asdf" ]]; then
        log_error "asdf is not installed. Please run install.sh first."
        exit 1
    fi
    
    # Source asdf
    . "$HOME/.asdf/asdf.sh"
}

# Install PHP
install_php() {
    log_section "Installing PHP"
    
    # Install PHP dependencies (Ubuntu/Debian)
    if command -v apt-get >/dev/null 2>&1; then
        log_info "Installing PHP build dependencies..."
        sudo apt-get install -y \
            autoconf \
            bison \
            build-essential \
            curl \
            gettext \
            git \
            libgd-dev \
            libcurl4-openssl-dev \
            libedit-dev \
            libicu-dev \
            libjpeg-dev \
            libonig-dev \
            libpng-dev \
            libpq-dev \
            libreadline-dev \
            libsqlite3-dev \
            libssl-dev \
            libxml2-dev \
            libzip-dev \
            openssl \
            pkg-config \
            re2c \
            zlib1g-dev
    fi
    
    # Install PHP dependencies (Arch)
    if command -v pacman >/dev/null 2>&1; then
        log_info "Installing PHP build dependencies..."
        sudo pacman -S --noconfirm --needed \
            autoconf \
            bison \
            curl \
            gettext \
            git \
            gd \
            icu \
            libedit \
            libjpeg-turbo \
            libpng \
            libxml2 \
            libzip \
            oniguruma \
            openssl \
            pkg-config \
            re2c \
            sqlite \
            zlib
    fi
    
    # Install latest PHP version
    local php_version=$(asdf list-all php | grep -E "^8\.[0-9]+\.[0-9]+$" | tail -1)
    log_info "Installing PHP $php_version..."
    asdf install php "$php_version"
    asdf global php "$php_version"
    
    log_info "PHP $php_version installed successfully"
    php -v
}

# Install Composer
install_composer() {
    log_section "Installing Composer"
    
    # Install latest Composer version
    local composer_version=$(asdf list-all composer | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
    log_info "Installing Composer $composer_version..."
    asdf install composer "$composer_version"
    asdf global composer "$composer_version"
    
    log_info "Composer $composer_version installed successfully"
    composer --version
    
    # Install global Composer packages
    log_info "Installing global Composer packages..."
    composer global require laravel/installer
    composer global require phpunit/phpunit
    composer global require friendsofphp/php-cs-fixer
    composer global require squizlabs/php_codesniffer
    
    log_info "Global Composer packages installed"
}

# Install Node.js
install_nodejs() {
    log_section "Installing Node.js"
    
    # Install latest LTS Node.js version
    local node_version=$(asdf list-all nodejs | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | grep -v "rc" | tail -1)
    log_info "Installing Node.js $node_version..."
    asdf install nodejs "$node_version"
    asdf global nodejs "$node_version"
    
    log_info "Node.js $node_version installed successfully"
    node -v
    npm -v
    
    # Install global npm packages
    log_info "Installing global npm packages..."
    npm install -g \
        yarn \
        pnpm \
        typescript \
        ts-node \
        @vue/cli \
        @angular/cli \
        create-react-app \
        vite \
        eslint \
        prettier \
        nodemon \
        pm2 \
        http-server \
        serve
    
    log_info "Global npm packages installed"
}

# Install Yarn
install_yarn() {
    log_section "Installing Yarn"
    
    # Install latest Yarn version
    local yarn_version=$(asdf list-all yarn | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
    log_info "Installing Yarn $yarn_version..."
    asdf install yarn "$yarn_version"
    asdf global yarn "$yarn_version"
    
    log_info "Yarn $yarn_version installed successfully"
    yarn --version
}

# Install Golang
install_golang() {
    log_section "Installing Golang"
    
    # Install latest Go version
    local go_version=$(asdf list-all golang | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
    log_info "Installing Golang $go_version..."
    asdf install golang "$go_version"
    asdf global golang "$go_version"
    
    log_info "Golang $go_version installed successfully"
    go version
    
    # Install useful Go tools
    log_info "Installing Go development tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/cosmtrek/air@latest
    
    log_info "Go development tools installed"
}

# Install additional tools
install_additional_tools() {
    log_section "Installing Additional Development Tools"
    
    # Install Docker Compose (if Docker is available)
    if command -v docker >/dev/null 2>&1; then
        log_info "Docker detected, installing docker-compose..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get install -y docker-compose
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm docker-compose
        fi
    fi
    
    # Install additional CLI tools based on OS
    log_info "Installing additional CLI tools..."
    
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y \
            silversearcher-ag \
            shellcheck \
            direnv \
            tldr
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm --needed \
            the_silver_searcher \
            shellcheck \
            direnv \
            tldr
    fi
    
    log_info "Additional tools installed"
}

# Show installed versions
show_versions() {
    log_section "Installed Versions Summary"
    
    echo "PHP: $(php -v 2>/dev/null | head -n 1 || echo 'Not installed')"
    echo "Composer: $(composer --version 2>/dev/null || echo 'Not installed')"
    echo "Node.js: $(node -v 2>/dev/null || echo 'Not installed')"
    echo "npm: $(npm -v 2>/dev/null || echo 'Not installed')"
    echo "Yarn: $(yarn --version 2>/dev/null || echo 'Not installed')"
    echo "Go: $(go version 2>/dev/null || echo 'Not installed')"
    
    log_section "asdf Plugins"
    asdf plugin list
    
    log_section "asdf Global Versions"
    asdf current
}

# Main installation flow
main() {
    log_info "Starting development tools installation..."
    log_info "================================================"
    
    check_asdf
    
    # Ask user what to install
    echo ""
    echo "What would you like to install?"
    echo "1) Everything (PHP, Node.js, Golang, and tools)"
    echo "2) PHP and Composer"
    echo "3) Node.js and Yarn"
    echo "4) Golang"
    echo "5) Custom selection"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            install_php
            install_composer
            install_nodejs
            install_yarn
            install_golang
            install_additional_tools
            ;;
        2)
            install_php
            install_composer
            ;;
        3)
            install_nodejs
            install_yarn
            ;;
        4)
            install_golang
            ;;
        5)
            read -p "Install PHP? (y/n): " install_php_choice
            [[ "$install_php_choice" == "y" ]] && install_php
            
            read -p "Install Composer? (y/n): " install_composer_choice
            [[ "$install_composer_choice" == "y" ]] && install_composer
            
            read -p "Install Node.js? (y/n): " install_node_choice
            [[ "$install_node_choice" == "y" ]] && install_nodejs
            
            read -p "Install Yarn? (y/n): " install_yarn_choice
            [[ "$install_yarn_choice" == "y" ]] && install_yarn
            
            read -p "Install Golang? (y/n): " install_go_choice
            [[ "$install_go_choice" == "y" ]] && install_golang
            
            read -p "Install additional tools? (y/n): " install_tools_choice
            [[ "$install_tools_choice" == "y" ]] && install_additional_tools
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    show_versions
    
    log_info "================================================"
    log_info "Development tools installation complete! 🎉"
    log_info ""
    log_info "You may need to restart your shell or run: source ~/.zshrc"
}

# Run main installation
main "$@"
