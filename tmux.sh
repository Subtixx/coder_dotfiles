#!/bin/bash

#set -e

. "$(dirname "$0")/common.sh"


# Install tmux if not present (Ubuntu only)
if ! command -v tmux &> /dev/null; then
    info "Installing tmux (Ubuntu)..."
    sudo apt-get update && sudo apt-get install -y tmux && success "tmux installed." || error "Failed to install tmux."
else
    info "tmux is already installed."
fi

# Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" && success "TPM installed." || error "Failed to install TPM."
else
    info "TPM is already installed."
fi

# Create a basic .tmux.conf with useful plugins
TMUX_CONF="$HOME/.tmux.conf"
cat > "$TMUX_CONF" <<'EOF'
# --- Tmux Configuration ---
set -g mouse on
set -g history-limit 10000
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
# PHP/Laravel/Composer/Dev plugins
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'tmux-plugins/tmux-sidebar'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-online-status'
# Cloud/Coder/laptop
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-sessionist'
set -g @plugin 'tmux-plugins/tmux-fpp'
# Reload config with prefix + r
bind r source-file ~/.tmux.conf \; run-shell "echo 'Tmux config reloaded!' | xargs info"

# TPM plugin installation shortcut
run '~/.tmux/plugins/tpm/tpm'
EOF

echo "Installing tmux plugins via TPM..."
# Install plugins non-interactively
"$TPM_DIR/bin/install_plugins"

echo "Tmux and plugins are installed and configured."
