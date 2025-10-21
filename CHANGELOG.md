# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-20

### Added
- Initial release of comprehensive dotfiles for development environments
- Main installation script (`install.sh`) with support for:
  - Arch Linux
  - Ubuntu/Debian
  - OS detection and package installation
- Oh My Zsh installation with plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
  - Powerlevel10k theme
- asdf version manager setup with plugins:
  - Node.js
  - PHP
  - Golang
  - Composer
  - Yarn
- tmux configuration with TPM and plugins:
  - tmux-resurrect
  - tmux-continuum
  - tmux-yank
  - tmux-copycat
  - tmux-pain-control
- Comprehensive `.zshrc` configuration with:
  - Useful aliases for Git, Docker, Laravel, Node.js, Composer
  - Custom functions
  - Enhanced history configuration
  - FZF integration
- Development tools installation script (`install-dev-tools.sh`) with:
  - Interactive installation menu
  - PHP and Composer setup
  - Node.js, npm, and Yarn setup
  - Golang tools installation
  - Global package installation
- Git configuration (`.gitconfig`) with:
  - Useful aliases
  - Better diff algorithms
  - Auto-correct
  - Rebase on pull by default
- Global gitignore patterns (`.gitignore_global`)
- asdf configuration (`.asdfrc`)
- EditorConfig file for consistent coding styles
- Example files:
  - `.tool-versions.example` for asdf
  - `.envrc.example` for direnv
- Comprehensive documentation:
  - README.md with installation and usage instructions
  - CONTRIBUTING.md with contribution guidelines
  - Coder-specific setup guide in `.coder/README.md`

### Features by Technology
- **PHP**: Full support with Laravel tools, Composer, PHP CS Fixer
- **Node.js/TypeScript**: Vue CLI, ESLint, Prettier, and modern tooling
- **Golang**: Development tools including gopls, delve, golangci-lint
- **Docker**: Aliases and configurations for Docker/Docker Compose
- **Git**: Enhanced configuration with productivity aliases

### Enhanced CLI Tools
- fzf (fuzzy finder)
- ripgrep (fast grep)
- bat (better cat)
- exa (better ls)
- fd (better find)
- htop (process viewer)
- jq (JSON processor)

[1.0.0]: https://github.com/Subtixx/coder_dotfiles/releases/tag/v1.0.0

## [1.1.0] - 2025-10-21

### Changed
- Reorganized repository layout: moved many top-level config files into a `config/` directory and shell scripts into `scripts/` to make the project structure clearer and easier to maintain. (commit: 320bfa3, 55127ed)
- Unified and modernized install scripts: split OS-specific logic into `scripts/os/` and misc helpers into `scripts/misc/`. Updated `install.sh` and `install-dev-tools.sh` to call the new helpers. (commits: 55127ed, 992d69c, 1a5e654)
- Improved shell startup and zsh configuration by splitting `.zshrc` into focused files under `config/.zsh/` (aliases, exports, functions, fzf, history, os, plugins) and adding a central `config/.zshrc`. (commit: 320bfa3)
- Refactored `common.sh` and other setup scripts for clearer function names and flow, including a corrected `detect_os` call in the main install flow. (commits: d7463f9, adad5a3, 27488a2)

### Added
- New per-OS install scripts: `scripts/os/arch.sh`, `scripts/os/ubuntu.sh`, and `scripts/os/alpine.sh` to encapsulate package installation for each supported distribution. (commit: 992d69c)
- New modular helper scripts in `scripts/misc/` for asdf, node, php, golang, tmux and zsh setup to simplify the installer and enable targeted setups. (commits: 55127ed, 992d69c)
- Split zsh config pieces added under `config/.zsh/` (aliases, asdf integration, exports, functions, fzf integration, history tweaks, OS-specific helpers, plugins). (commit: 320bfa3)

### Fixed
- Corrected function calls and package installation ordering in `install.sh` to prevent errors during initial setup. (commits: adad5a3, 193940c, 27488a2)
- Improved logging in setup scripts and added installation of additional zsh and asdf plugins for a more complete developer environment. (commit: d7463f9)

### Removed
- Removed several legacy one-off scripts and duplicated configuration files that were moved into the new `config/` and `scripts/` directories. This includes older top-level versions of `zsh` and `tmux` helper scripts. (commits: 1a5e654, 55127ed)

[1.1.0]: https://github.com/Subtixx/coder_dotfiles/releases/tag/v1.1.0
