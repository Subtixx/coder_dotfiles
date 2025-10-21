
# Development tools installation script (modular, matches install.sh style)
# Author: Subtixx
# Description: Installs language versions and dev tools using asdf

set -e

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
    . "$SCRIPT_DIR/common.sh"
else
    # Fallback logging if common.sh not found
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
    log_section() { echo "==== $1 ===="; }
fi

# Helper: return latest stable semantic version (X.Y.Z) for an asdf plugin.
get_latest_stable() {
    local plugin="$1"
    local extra_regex="$2"
    local list
    list=$(asdf list-all "$plugin" 2>/dev/null || true)
    if [[ -z "$list" ]]; then
        echo ""
        return
    fi
    if [[ -n "$extra_regex" ]]; then
        echo "$list" | grep -E "$extra_regex" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 || true
    else
        echo "$list" | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 || true
    fi
}

# Check asdf and source
check_asdf() {
    if [[ ! -d "$HOME/.asdf" ]]; then
        log_error "asdf is not installed. Please run install.sh first."
        exit 1
    fi
    . "$HOME/.asdf/asdf.sh"
}

# Ensure asdf plugins are present
ensure_asdf_plugin() {
    local plugin="$1"
    local repo="$2"
    if ! asdf plugin list | grep -q "$plugin"; then
        log_info "Adding asdf plugin: $plugin"
        asdf plugin add "$plugin" "$repo"
    fi
}

# Install PHP
install_php() {
    log_section "Installing PHP"
    # ...existing code for installing PHP dependencies...
    if command -v apt-get >/dev/null 2>&1; then
        log_info "Installing PHP build dependencies..."
        sudo apt-get install -y \
            autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev \
            libedit-dev libicu-dev libjpeg-dev libonig-dev libpng-dev libpq-dev libreadline-dev \
            libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev
    elif command -v pacman >/dev/null 2>&1; then
        log_info "Installing PHP build dependencies..."
        sudo pacman -S --noconfirm --needed \
            autoconf bison curl gettext git gd icu libedit libjpeg-turbo libpng libxml2 libzip \
            oniguruma openssl pkg-config re2c sqlite zlib
    fi
    ensure_asdf_plugin php https://github.com/asdf-community/asdf-php.git
    local php_version
    php_version=$(get_latest_stable php "^8\.[0-9]+\.[0-9]+$")
    if [[ -z "$php_version" ]]; then
        log_error "Could not determine a stable PHP 8.x version to install."
        exit 1
    fi
    log_info "Installing PHP $php_version..."
    asdf install php "$php_version"
    asdf global php "$php_version"
    log_info "PHP $php_version installed successfully"
    php -v
}

# Install Composer
install_composer() {
    log_section "Installing Composer"
    # Download and install Composer globally
    EXPECTED_SIGNATURE=$(curl -s https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
        log_error 'ERROR: Invalid Composer installer signature'
        rm composer-setup.php
        exit 1
    fi
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    RESULT=$?
    rm composer-setup.php
    if [ $RESULT -ne 0 ]; then
        log_error "Composer installation failed."
        exit 1
    fi
    log_info "Composer installed successfully"
    composer --version
    log_info "Installing global Composer packages..."
    composer global require laravel/installer phpunit/phpunit friendsofphp/php-cs-fixer squizlabs/php_codesniffer
    log_info "Global Composer packages installed"
}

# Install Node.js
install_nodejs() {
    log_section "Installing Node.js"
    ensure_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git
    local node_version
    node_version=$(get_latest_stable nodejs)
    if [[ -z "$node_version" ]]; then
        log_error "Could not determine a stable Node.js version to install."
        exit 1
    fi
    log_info "Installing Node.js $node_version..."
    asdf install nodejs "$node_version"
    asdf global nodejs "$node_version"
    log_info "Node.js $node_version installed successfully"
    node -v
    npm -v
    log_info "Installing global npm packages..."
    npm install -g yarn pnpm typescript ts-node @vue/cli @angular/cli create-react-app vite eslint prettier nodemon pm2 http-server serve
    log_info "Global npm packages installed"
}

# Install Golang
install_golang() {
    log_section "Installing Golang"
    ensure_asdf_plugin golang https://github.com/asdf-community/asdf-golang.git
    local go_version
    go_version=$(get_latest_stable golang)
    if [[ -z "$go_version" ]]; then
        log_error "Could not determine a stable Golang version to install."
        exit 1
    fi
    log_info "Installing Golang $go_version..."
    asdf install golang "$go_version"
    asdf global golang "$go_version"
    log_info "Golang $go_version installed successfully"
    go version
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
    if command -v docker >/dev/null 2>&1; then
        log_info "Docker detected, installing docker-compose..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get install -y docker-compose
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm docker-compose
        fi
    fi
    log_info "Installing additional CLI tools..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get install -y silversearcher-ag shellcheck direnv tldr
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm --needed the_silver_searcher shellcheck direnv tldr
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
    echo "Go: $(go version 2>/dev/null || echo 'Not installed')"
    log_section "asdf Plugins"
    asdf plugin list
    log_section "asdf Global Versions"
    asdf current
}
