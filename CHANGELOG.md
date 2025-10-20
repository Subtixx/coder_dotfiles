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
