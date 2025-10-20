#!/bin/bash
#set -e

. "$(dirname "$0")/common.sh"


SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Find workspace root by going up from SCRIPT_DIR until config_files exists
WORKSPACE_ROOT="$SCRIPT_DIR"
while [ ! -d "$WORKSPACE_ROOT/config_files" ] && [ "$WORKSPACE_ROOT" != "/" ]; do
	WORKSPACE_ROOT="$(dirname "$WORKSPACE_ROOT")"
done
CONFIG_SRC_DIR="$WORKSPACE_ROOT/config_files"

info "Running all setup scripts in $SCRIPT_DIR ..."

for script in "$SCRIPT_DIR"/*.sh; do
	# Skip this install.sh itself
	if [[ "$script" != "$SCRIPT_DIR/install.sh" ]]; then
		info "Executing $script ..."
		bash "$script"
		success "$script completed."
	fi
done

info "Copying config files from $CONFIG_SRC_DIR ..."
find "$CONFIG_SRC_DIR" -type f | while read -r src; do
	rel_path="${src#$CONFIG_SRC_DIR/}"
	dest="$HOME/$rel_path"
	dest_dir="$(dirname "$dest")"
	mkdir -p "$dest_dir"
	cp "$src" "$dest"
	success "Copied $src to $dest"
done

success "All setup scripts executed and config files copied."