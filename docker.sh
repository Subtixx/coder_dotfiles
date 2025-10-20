#!/bin/bash
#set -e

# Source common color and logging functions
. "$(dirname "$0")/common.sh"

info "Removing old Docker versions (if any)"
sudo apt-get remove -y docker docker-engine docker.io containerd runc || warn "No old Docker versions found."

info "Updating apt and installing dependencies"
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates gnupg curl python3 python3-pip || error "Failed to install dependencies."

info "Adding Docker GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && success "Docker GPG key added." || error "Failed to add Docker GPG key."

info "Adding Docker repository"
. /etc/os-release
sudo tee /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable
EOF

info "Installing Docker packages"
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli docker-compose-plugin && success "Docker installed successfully." || error "Failed to install Docker."

info "Adding user $USER to docker group"
sudo usermod -aG docker "$USER" && success "User $USER added to docker group." || error "Failed to add user to docker group."
