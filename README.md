# Coder Dotfiles

A comprehensive dotfiles setup for development environments using [Coder](https://coder.com). This repository contains configuration files and installation scripts for a modern, productive development setup with support for multiple operating systems.

## Features

- 🐚 **Zsh** with Oh My Zsh and Powerlevel10k theme
- 📦 **asdf** version manager for multiple languages
- 🖥️ **tmux** with useful plugins and configurations
- 🔧 **Multi-language support**: PHP, Node.js, Golang, TypeScript, Vue.js
- 🎨 **Enhanced CLI tools**: fzf, ripgrep, bat, exa, and more
- 🌍 **Multi-OS support**: Arch Linux, Ubuntu/Debian
- ⚡ **Quick installation** with automated scripts

## Supported Technologies

### Languages & Frameworks
- **PHP** with Composer and Laravel support
- **Node.js** with npm and Yarn
- **Golang** with development tools
- **TypeScript** for modern JavaScript development
- **Vue.js** for frontend development

### Tools & Utilities
- **Git** with enhanced configuration
- **Docker** and Docker Compose
- **Modern CLI tools**: fzf, ripgrep, bat, exa, fd, htop
- **Development tools**: ESLint, Prettier, PHP CS Fixer, Golangci-lint

## Quick Start

### Prerequisites

- A Unix-like operating system (Arch Linux or Ubuntu/Debian)
- `sudo` access for package installation
- `git` installed

### Installation

1. Clone this repository:
```bash
git clone https://github.com/Subtixx/coder_dotfiles.git
cd coder_dotfiles
```

2. Run the main installation script:
```bash
./install.sh
```

This will:
- Install system packages
- Set up Oh My Zsh with plugins
- Install asdf version manager
- Configure tmux with plugins
- Copy dotfiles to your home directory
- Change your default shell to zsh

3. Install development tools and language versions:
```bash
./install-dev-tools.sh
```

Choose what to install:
- All tools (recommended for full setup)
- Individual languages (PHP, Node.js, Golang)
- Custom selection

4. Restart your terminal or source the configuration:
```bash
source ~/.zshrc
```

## File Structure

```
.
├── install.sh              # Main installation script
├── install-dev-tools.sh    # Development tools installation
├── .zshrc                  # Zsh configuration
├── .tmux.conf              # Tmux configuration
├── .gitconfig              # Git configuration
├── .gitignore_global       # Global gitignore patterns
├── .asdfrc                 # asdf configuration
└── README.md               # This file
```

## Configuration Details

### Zsh Configuration (.zshrc)

Features included:
- **Powerlevel10k theme** for a beautiful, informative prompt
- **Oh My Zsh plugins**:
  - git, docker, docker-compose
  - npm, yarn, composer, laravel
  - golang, node, asdf
  - tmux, fzf, z
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
- **Custom aliases** for common tasks
- **Useful functions** for development
- **Enhanced history** configuration
- **FZF integration** for fuzzy finding

#### Key Aliases

**General:**
```bash
ll          # List files with details
la          # List all files including hidden
reload      # Reload zsh configuration
```

**Git:**
```bash
gst         # git status
glog        # Pretty git log
gac <msg>   # git add . && git commit -m
gacp <msg>  # git add . && commit && push
```

**Docker:**
```bash
dc          # docker-compose
dcu         # docker-compose up -d
dcd         # docker-compose down
dcl         # docker-compose logs -f
```

**Laravel:**
```bash
art         # php artisan
tinker      # php artisan tinker
migrate     # php artisan migrate
serve       # php artisan serve
```

**Node/NPM:**
```bash
ni          # npm install
nr          # npm run
nrd         # npm run dev
nrb         # npm run build
```

**Composer:**
```bash
ci          # composer install
cu          # composer update
cr          # composer require
cda         # composer dump-autoload
```

### Tmux Configuration (.tmux.conf)

Features:
- **Mouse support** enabled
- **True color support** for modern terminals
- **Vim-style navigation** for panes
- **Custom key bindings** for productivity
- **Tmux Plugin Manager (TPM)** with plugins:
  - tmux-resurrect: Save and restore sessions
  - tmux-continuum: Automatic session saving
  - tmux-yank: Better copy/paste
  - tmux-copycat: Advanced search
  - tmux-pain-control: Better pane management

#### Key Bindings

- `Prefix + |` - Split pane vertically
- `Prefix + -` - Split pane horizontally
- `Prefix + h/j/k/l` - Navigate panes (vim-style)
- `Prefix + H/J/K/L` - Resize panes
- `Alt + Arrow` - Navigate panes without prefix
- `Prefix + r` - Reload tmux configuration

### Git Configuration (.gitconfig)

Features:
- **Better diff algorithm** (histogram)
- **Useful aliases** for common operations
- **Auto-correct typos**
- **Colored output**
- **Rebase on pull** by default
- **Automatic branch pruning**
- **Git LFS support**

### asdf Configuration

Pre-configured plugins:
- **nodejs** - Node.js version management
- **php** - PHP version management
- **golang** - Go version management
- **composer** - Composer version management
- **yarn** - Yarn version management

## Usage

### Managing Language Versions with asdf

List available versions:
```bash
asdf list-all nodejs
asdf list-all php
asdf list-all golang
```

Install a specific version:
```bash
asdf install nodejs 20.10.0
asdf install php 8.3.0
asdf install golang 1.21.5
```

Set global version:
```bash
asdf global nodejs 20.10.0
asdf global php 8.3.0
asdf global golang 1.21.5
```

Set local version for a project:
```bash
cd my-project
asdf local nodejs 18.19.0
```

### Using Tmux

Start a new session:
```bash
tmux new -s mysession
```

Attach to existing session:
```bash
tmux attach -t mysession
```

List sessions:
```bash
tmux list-sessions
# or use alias
tl
```

### Customization

#### Personal Git Configuration

Edit `~/.gitconfig` to add your name and email:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### Zsh Customization

Add your custom configurations to `~/.zshrc.local` (this file is sourced automatically):
```bash
echo 'export MY_CUSTOM_VAR="value"' >> ~/.zshrc.local
```

#### Powerlevel10k Theme

Configure the prompt appearance:
```bash
p10k configure
```

## Updating

### Update Oh My Zsh
```bash
omz update
```

### Update asdf and plugins
```bash
asdf update
asdf plugin update --all
```

### Update Tmux plugins
Press `Prefix + U` in tmux (default: Ctrl+b then Shift+U)

### Update dotfiles
```bash
cd ~/coder_dotfiles
git pull
./install.sh  # Re-run to update configurations
```

## Troubleshooting

### Shell not changing to zsh
Manually change the shell:
```bash
chsh -s $(which zsh)
```

### asdf command not found
Source asdf manually:
```bash
source ~/.asdf/asdf.sh
```

### Tmux plugins not loading
Install plugins manually:
1. Press `Prefix + I` in tmux (Ctrl+b then Shift+I)
2. Or run: `~/.tmux/plugins/tpm/bin/install_plugins`

### Oh My Zsh plugins not working
Reinstall plugins:
```bash
rm -rf ~/.oh-my-zsh/custom/plugins/*
./install.sh
```

## OS-Specific Notes

### Ubuntu/Debian
- Some packages may have different names (e.g., `batcat` instead of `bat`)
- The installation script creates symlinks for compatibility

### Arch Linux
- Uses `pacman` for package management
- All packages use standard names

## Additional Recommendations

### Fonts
Install a Nerd Font for better icon support with Powerlevel10k:
- [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
- [Meslo Nerd Font](https://github.com/romkatv/powerlevel10k#fonts)

### VS Code Extensions
- PHP Intelephense
- Volar (Vue.js)
- Go
- ESLint
- Prettier

### Development Databases
Consider installing:
- PostgreSQL: `sudo pacman -S postgresql` or `sudo apt-get install postgresql`
- MySQL/MariaDB: `sudo pacman -S mariadb` or `sudo apt-get install mysql-server`
- Redis: `sudo pacman -S redis` or `sudo apt-get install redis-server`

## Contributing

Feel free to fork this repository and customize it for your needs. Pull requests are welcome!

## License

This project is open source and available under the [MIT License](LICENSE).

## Credits

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [asdf](https://asdf-vm.com/)
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- All the amazing plugin and tool authors

## Support

If you encounter issues or have questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review configuration files for syntax errors
3. Check tool documentation (Oh My Zsh, asdf, tmux)
4. Open an issue in this repository