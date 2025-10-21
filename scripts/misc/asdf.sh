#!/bin/bash

set -e

if ! declare -f log_info >/dev/null 2>&1; then
    echo "Error: common.sh must be sourced before asdf.sh"
    exit 1
fi

asdf_clear_old() {
    # Safely remove top-level entries under ASDF_DATA_DIR except a few keepers.
    # Use a loop to handle filenames with spaces and use rm -rf to accept all prompts.
    local dir="${ASDF_DATA_DIR:-$HOME/.asdf}"

    # If the directory doesn't exist, nothing to do.
    if [[ ! -d "$dir" ]]; then
        return 0
    fi

    # Iterate over immediate children only.
    shopt -s nullglob dotglob
    local entry
    for entry in "$dir"/*; do
        # Skip if entry doesn't exist (in case of empty dir)
        [[ -e "$entry" ]] || continue

        case "$(basename "$entry")" in
            downloads|plugins|installs|shims)
                # keep these
                ;;
            *)
                # Try to remove the entry. If removal fails (for example due to
                # permissions), do not abort the whole script — log a helpful
                # warning with the file owner and mode so the user can take
                # corrective action (chown or sudo). This avoids the script
                # exiting under 'set -e' when encountering 'Permission denied'.
                rm -rf -- "$entry" || {
                    # Gather ownership/mode info for remediation guidance.
                    if ls -ld -- "$entry" >/dev/null 2>&1; then
                        local perms owner group
                        perms=$(stat -c '%A' -- "$entry" 2>/dev/null || true)
                        owner=$(stat -c '%U' -- "$entry" 2>/dev/null || true)
                        group=$(stat -c '%G' -- "$entry" 2>/dev/null || true)
                        log_warn "Could not remove '$entry' due to permission issues."
                        log_warn "Owner: ${owner:-unknown}, Group: ${group:-unknown}, Mode: ${perms:-unknown}."
                    else
                        log_warn "Could not remove '$entry' and file no longer exists or is inaccessible."
                    fi
                    log_warn "To fix: run 'sudo rm -rf \"$entry\"' or change ownership: 'sudo chown -R \$USER:\$USER \"$entry\"' then retry."
                }
                ;;
        esac
    done
    shopt -u nullglob dotglob
}

# Install asdf
asdf_install() {
    log_info "Installing asdf version manager..."

    if [[ -d "$HOME/.asdf" ]]; then
        log_warn "asdf already installed, updating..."
        # Use common helper to safely update the asdf repo
        git_safe_update_repo "$HOME/.asdf" "origin"
    else
        run_and_log git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.18.0
    fi
    export ASDF_DATA_DIR="$HOME/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH:$ASDF_DATA_DIR/bin"

    asdf_clear_old

    log_info "asdf installed successfully"
    asdf version
    asdf reshim

    asdf_install_plugins
}

asdf_install_plugins() {
    # Install asdf plugins
    log_info "Installing asdf plugins..."

    # Node.js
    if ! asdf plugin list | grep -q nodejs; then
        log_info "Installing asdf plugin for Node.js..."
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    fi

    # PHP
    if ! asdf plugin list | grep -q php; then
        log_info "Installing asdf plugin for PHP..."
        asdf plugin add php https://github.com/asdf-community/asdf-php.git
    fi

    # Golang
    if ! asdf plugin list | grep -q golang; then
        log_info "Installing asdf plugin for Golang..."
        asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    fi

    log_info "asdf plugins installed successfully"
}

asdf_get_latest_stable() {
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
asdf_check() {
    if [[ ! -d "$HOME/.asdf" ]]; then
        log_error "asdf is not installed. Please run install.sh first."
        exit 1
    fi
    log_info "Sourcing asdf..."
    . "$HOME/.asdf/asdf.sh"
    log_info "asdf sourced successfully"
}

# Ensure asdf plugins are present
asdf_ensure_plugin() {
    local plugin="$1"
    local repo="$2"
    if ! asdf plugin list | grep -q "$plugin"; then
        log_info "Adding asdf plugin: $plugin"
        asdf plugin add "$plugin" "$repo"
    else
        log_info "asdf plugin $plugin already exists"
    fi
}
