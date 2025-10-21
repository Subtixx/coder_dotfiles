#!/bin/bash

# All os scripts should implement these functions:
# detect_package_manager
# os_start_package_install
# os_stop_package_install
# os_is_package_installed
# os_install_package
# os_install_packages

# Package manager session state
PACKAGE_MANAGER_INITIALIZED=false
PACKAGE_CACHE_FILE="/tmp/package_install_cache.$$"

IS_DEBUG=false

# Colors for output
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'

# Bright colors
BRIGHT_BLACK='\033[1;30m'
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;35m'
BRIGHT_CYAN='\033[1;36m'
BRIGHT_WHITE='\033[1;37m'

# Background colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Bright background colors
BG_BRIGHT_BLACK='\033[100m'
BG_BRIGHT_RED='\033[101m'
BG_BRIGHT_GREEN='\033[102m'
BG_BRIGHT_YELLOW='\033[103m'
BG_BRIGHT_BLUE='\033[104m'
BG_BRIGHT_MAGENTA='\033[105m'
BG_BRIGHT_CYAN='\033[106m'
BG_BRIGHT_WHITE='\033[107m'

NC='\033[0m' # No Color

log_message() {
	local level="$1"
	local msg="$2"
	local datetime="$(date '+%Y-%m-%d %H:%M:%S')"
	local color=""
	case "$level" in
		DEBUG)
			color="$CYAN"
			;;
		INFO)
			color="$GREEN"
			;;
		WARN)
			color="$YELLOW"
			;;
		ERROR)
			color="$RED"
			;;
		*)
			color="$NC"
			;;
	esac
	# Console output (padded)
	printf "%b[%-7s%b] [%-19s] %s\n" "$color" "$level" "$NC" "$datetime" "$msg"
	# File output (padded)
	printf "[%-7s] [%-19s] %s\n" "$level" "$datetime" "$msg" >> /tmp/startup.log
}

log_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

log_debug() {
	if [[ "$IS_DEBUG" == true ]]; then
		log_message DEBUG "$1"
	fi
}

log_info() {
	log_message INFO "$1"
}

log_warn() {
	log_message WARN "$1"
}

log_error() {
	log_message ERROR "$1"
}

# Show installed versions
show_versions() {
    log_section "Installed Versions Summary"
    echo "PHP: $(php -v 2>/dev/null | head -n 1 || echo 'Not installed')"
    echo "Composer: $(composer --version 2>/dev/null || echo 'Not installed')"
    echo "Node.js: $(node -v 2>/dev/null || echo 'Not installed')"
    echo "npm: $(npm -v 2>/dev/null || echo 'Not installed')"
    echo "Go: $(go version 2>/dev/null || echo 'Not installed')"

	if command -v asdf >/dev/null 2>&1; then
		echo "asdf: $(asdf --version 2>/dev/null || echo 'Not installed')"
		log_section "asdf Plugins"
		asdf plugin list
		log_section "asdf Global Versions"
		asdf current
	fi
}

run_with_sudo() {
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

# Source the OS-specific script once
source_os_script() {
	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

	if [[ -z "$OS" ]]; then
		detect_os
	fi

	case "$OS" in
		arch|manjaro)
			. "$script_dir/arch.sh"
			;;
		ubuntu|debian)
			. "$script_dir/ubuntu.sh"
			;;
		alpine)
			. "$script_dir/alpine.sh"
			;;
		*)
			log_error "Unsupported OS: $OS"
			exit 1
			;;
	esac
}

# Start package install session: update package index and create cache
start_package_install() {
	PACKAGE_MANAGER_INITIALIZED=true
	> "$PACKAGE_CACHE_FILE"
	os_start_package_install
	log_info "Package install session started. Cache: $PACKAGE_CACHE_FILE"
}

# Stop package install session: remove cache
stop_package_install() {
	PACKAGE_MANAGER_INITIALIZED=false
	if [[ -f "$PACKAGE_CACHE_FILE" ]]; then
		os_stop_package_install
		rm -f "$PACKAGE_CACHE_FILE"
		log_info "Package install session stopped. Cache deleted."
	fi
}

# Detect OS
detect_os() {
	if [[ -f /etc/os-release ]]; then
		. /etc/os-release
		OS=$ID
		OS_VERSION=$VERSION_ID
	elif [[ -f /etc/arch-release ]]; then
		OS="arch"
	elif [[ -f /etc/alpine-release ]]; then
		OS="alpine"
	else
		log_error "Could not detect OS. Supported: Arch Linux, Ubuntu, Alpine"
		exit 1
	fi
	log_info "Detected OS: $OS"
}

# Install a single package by name
install_package() {
	local pkg="$1"
	if [[ "$PACKAGE_MANAGER_INITIALIZED" != true ]]; then
		log_error "Package manager session not initialized. Call start_package_install first."
		return 1
	fi
	if [[ -z "$pkg" ]]; then
		log_error "No package name provided to install_package"
		return 1
	fi
	echo "$pkg" >> "$PACKAGE_CACHE_FILE"
    log_info "Installing $pkg..."
    os_install_package "$pkg"
    log_info "Installed package: $pkg"
}

# Install packages based on OS
install_packages() {
	if [[ "$PACKAGE_MANAGER_INITIALIZED" != true ]]; then
		log_error "Package manager session not initialized. Call start_package_install first."
		return 1
	fi
	log_info "Installing system packages..."
	os_install_packages
	log_info "System packages installed successfully"
}

install_system_packages() {
	if [[ "$PACKAGE_MANAGER_INITIALIZED" != true ]]; then
		log_error "Package manager session not initialized. Call start_package_install first."
		return 1
	fi
	log_info "Installing system packages..."
	os_install_system_packages
	log_info "System packages installed successfully"
}