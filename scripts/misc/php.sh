#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before this script."
    exit 1
fi

# Install PHP
php_install() {
    log_section "Installing PHP"
    detect_os
    local php_packages
    if [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        php_packages="autoconf bison curl gettext git gd icu libedit libjpeg-turbo libpng libxml2 libzip oniguruma openssl pkg-config re2c sqlite zlib"
    elif [[ "$OS" == "alpine" ]]; then
        php_packages="autoconf bison build-base curl gettext-dev git gd-dev icu-dev libedit-dev libjpeg-turbo-dev libpng-dev libxml2-dev libzip-dev oniguruma-dev openssl-dev pkgconfig re2c sqlite-dev zlib-dev"
    else
        php_packages="autoconf bison build-essential curl gettext git libgd-dev libcurl4-openssl-dev libedit-dev libicu-dev libjpeg-dev libonig-dev libpng-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libzip-dev openssl pkg-config re2c zlib1g-dev"
    fi
    log_info "Installing PHP build dependencies..."
    install_packages $php_packages
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

    php_install_composer
    php_install_composer_packages
}

# Install Composer
php_install_composer() {
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
}

php_install_composer_packages() {
    log_section "Installing Additional PHP Composer Packages"
    local packages=(
        laravel/installer
        phpunit/phpunit
        friendsofphp/php-cs-fixer
        squizlabs/php_codesniffer
    )
    for package in "${packages[@]}"; do
        log_info "Installing Composer package: $package"
        composer global require "$package"
    done
    log_info "Additional PHP Composer packages installed"
}