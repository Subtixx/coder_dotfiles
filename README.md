[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A compact, script-driven dotfiles repository that configures a productive
developer shell and common CLI tooling. Intended for reproducible environments
on Linux (Ubuntu/Debian, Arch) and other Unix-like systems.

Why this repo
- Fast bootstrap for a consistent dev environment.
- Reusable OS-specific installers and small, audited scripts.
- Focused on zsh, tmux, and language toolchains via asdf.

Table of contents
- Features
- Quick start
- What the scripts do
- Examples
- Notes & troubleshooting
- Contributing & license

Features
- zsh configuration (Oh My Zsh + optional Powerlevel10k)
- tmux config and TPM wiring for plugin management
- asdf plugin wiring for common languages (node, php, golang, etc.)
- Scripted installers with OS helpers: `scripts/os/`

Quick start
1. Clone the repo:

```bash
git clone https://github.com/Subtixx/coder_dotfiles.git
cd coder_dotfiles
```

2. Inspect the scripts and run the installers (interactive):

```bash
./scripts/install.sh           # core packages and dotfiles
./scripts/install-dev-tools.sh # language/toolchain install (asdf)
```

3. Reload your shell:

```bash
source ~/.zshrc
# or open a new terminal
```

What the scripts do
- `scripts/install.sh`
  - Installs system packages (using OS helper scripts)
  - Creates/updates dotfile symlinks
  - Optionally installs Oh My Zsh and Powerlevel10k
  - Installs TPM and basic tmux wiring
- `scripts/install-dev-tools.sh`
  - Installs asdf and configured language plugins
  - Installs common developer CLIs (node, composer, yarn, go, etc.)
- `scripts/os/*.sh`
  - Distro-specific package lists and helper functions used by `install.sh`

Repository layout

```
coder_dotfiles/
├─ scripts/
│  ├─ install.sh
│  ├─ install-dev-tools.sh
│  └─ os/           # ubuntu.sh, arch.sh, alpine.sh
├─ config/          # templates and extra config snippets
├─ LICENSE
├─ .gitignore_global
└─ README.md
```

Examples

- tmux: start or attach to a session

```bash
tmux new -s work        # start a new session named 'work'
tmux attach -t work     # attach
```

- asdf: list and install versions

```bash
asdf list-all nodejs
asdf install nodejs 18.19.0
asdf global nodejs 18.19.0
```

- Useful aliases are provided in the zsh config (inspect `config/` for
  exact definitions). Typical aliases include `gst` (git status), `tl` (tmux
  list-sessions), and `ni` (npm install).

Notes & troubleshooting
- Review `scripts/install.sh` before running — it makes system changes.
- On Ubuntu some package names differ (e.g., `bat` vs `batcat`); the installer
  attempts to handle these in `scripts/os/ubuntu.sh`.
- If `asdf` isn't available after install, ensure the asdf lines are sourced in
  your `~/.zshrc` or run `source ~/.asdf/asdf.sh`.
- To install tmux plugins manually:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```
