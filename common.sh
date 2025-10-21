#!/bin/bash

# Package manager session state
PACKAGE_MANAGER_INITIALIZED=false
PACKAGE_CACHE_FILE="/tmp/package_install_cache.$$"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_message() {
	local level="$1"
	local msg="$2"
	local datetime="$(date '+%Y-%m-%d %H:%M:%S')"
	local color=""
	case "$level" in
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

log_info() {
	log_message INFO "$1"
}

log_warn() {
	log_message WARN "$1"
}

log_error() {
	log_message ERROR "$1"
}

# Source the OS-specific script once
source_os_script() {
	local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
