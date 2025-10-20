# Coder Workspace Setup

This directory contains example configurations for using these dotfiles with Coder workspaces.

## Quick Setup

When creating a new Coder workspace, you can automatically set up your environment:

### Option 1: Clone and Install (Recommended)

Add to your Coder template's startup script:

```bash
#!/bin/bash

# Clone dotfiles if not already present
if [ ! -d "$HOME/coder_dotfiles" ]; then
    git clone https://github.com/Subtixx/coder_dotfiles.git "$HOME/coder_dotfiles"
fi

# Run installation
cd "$HOME/coder_dotfiles"
./install.sh

# Optionally install development tools automatically
# Uncomment the line below to install all tools without prompting
# echo "1" | ./install-dev-tools.sh
```

### Option 2: Direct Installation

For a quicker setup during workspace creation:

```bash
#!/bin/bash

# Download and run installation
curl -fsSL https://raw.githubusercontent.com/Subtixx/coder_dotfiles/main/install.sh | bash
```

### Option 3: Manual Installation

1. Open terminal in your Coder workspace
2. Clone the repository:
   ```bash
   git clone https://github.com/Subtixx/coder_dotfiles.git
   cd coder_dotfiles
   ```
3. Run installation:
   ```bash
   ./install.sh
   ```
4. Install development tools:
   ```bash
   ./install-dev-tools.sh
   ```

## Coder Template Example

Here's an example Coder template configuration (Terraform):

```hcl
terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.12.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "coder_agent" "main" {
  os   = "linux"
  arch = "amd64"
  
  startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Clone dotfiles
    if [ ! -d "$HOME/coder_dotfiles" ]; then
        git clone https://github.com/Subtixx/coder_dotfiles.git "$HOME/coder_dotfiles"
    fi
    
    # Install dotfiles
    cd "$HOME/coder_dotfiles"
    ./install.sh
    
    # Auto-install all development tools (optional)
    # echo "1" | ./install-dev-tools.sh
  EOT
}

resource "docker_container" "workspace" {
  image = "ubuntu:24.04"
  name  = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  
  # Add environment variables
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
  ]
}
```

## Environment Variables

You can customize the installation using environment variables:

```bash
# Skip changing default shell
export SKIP_SHELL_CHANGE=1

# Use specific theme
export ZSH_THEME="robbyrussell"

# Skip specific installations
export SKIP_OHMYZSH=1
export SKIP_ASDF=1
export SKIP_TMUX=1
```

## Best Practices

1. **Version Control**: Keep your personal modifications in a fork
2. **Workspace Persistence**: Use Coder's persistent volume for home directory
3. **Secrets Management**: Use Coder's secrets feature for sensitive data
4. **Resource Limits**: Consider resource requirements when installing all tools
5. **Regular Updates**: Pull latest changes periodically: `cd ~/coder_dotfiles && git pull`

## Troubleshooting in Coder

### Workspace Creation Fails

1. Check Coder logs for errors
2. Verify network connectivity
3. Ensure sufficient resources (CPU, memory)

### Dotfiles Not Applied

1. Verify installation script ran successfully
2. Check if shell was changed to zsh: `echo $SHELL`
3. Try restarting the workspace

### Performance Issues

1. Reduce number of zsh plugins
2. Use lighter theme (robbyrussell instead of powerlevel10k)
3. Disable tmux auto-restoration

## Support

For issues specific to Coder integration, please:

1. Check Coder documentation: https://coder.com/docs
2. Open an issue in this repository with `[Coder]` prefix
3. Include Coder version and workspace configuration
