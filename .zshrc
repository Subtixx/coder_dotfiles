# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# Options: robbyrussell, agnoster, powerlevel10k/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt (should stay close to the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    docker-compose
    npm
    yarn
    composer
    laravel
    golang
    node
    asdf
    tmux
    fzf
    z
    colored-man-pages
    command-not-found
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# ===========================
# Custom Aliases
# ===========================

# General shortcuts
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias reload="source ~/.zshrc"

# Enhanced ls with exa (if available)
if command -v exa > /dev/null 2>&1; then
    alias ls="exa --icons"
    alias ll="exa -l --icons --git"
    alias la="exa -la --icons --git"
    alias lt="exa --tree --level=2 --icons"
else
    alias ll="ls -lh"
    alias la="ls -lAh"
fi

# Better cat with bat (if available)
if command -v bat > /dev/null 2>&1; then
    alias cat="bat --style=auto"
fi

# Git aliases (additional to plugin)
alias gst="git status"
alias glog="git log --oneline --decorate --graph --all"
alias gca="git commit -a"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"

# Docker aliases
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias dcl="docker-compose logs -f"
alias dps="docker ps"
alias dimg="docker images"

# Laravel aliases
alias art="php artisan"
alias tinker="php artisan tinker"
alias migrate="php artisan migrate"
alias seed="php artisan db:seed"
alias serve="php artisan serve"

# Node/NPM aliases
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"

# Yarn aliases
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yr="yarn run"
alias yrd="yarn run dev"
alias yrb="yarn run build"

# Composer aliases
alias ci="composer install"
alias cu="composer update"
alias cr="composer require"
alias crd="composer require --dev"
alias cda="composer dump-autoload"

# Tmux aliases
alias ta="tmux attach -t"
alias tad="tmux attach -d -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"

# System aliases
alias update-system="sudo pacman -Syu || sudo apt update && sudo apt upgrade -y"
alias cleanup="sudo pacman -Rns \$(pacman -Qtdq) 2>/dev/null || sudo apt autoremove -y"

# ===========================
# Environment Variables
# ===========================

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Composer
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Load asdf
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    . "$HOME/.asdf/asdf.sh"
    # append completions to fpath
    fpath=(${ASDF_DIR}/completions $fpath)
    # initialise completions with ZSH's compinit
    autoload -Uz compinit && compinit
fi

# ===========================
# Additional Configuration
# ===========================

# FZF configuration
if command -v fzf > /dev/null 2>&1; then
    # Use fd instead of find if available
    if command -v fd > /dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # FZF color scheme
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
fi

# Enable vi mode (optional, uncomment if you prefer vi keybindings)
# bindkey -v

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# ===========================
# Functions
# ===========================

# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && cd "$_" || return
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find and kill process by name
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    
    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

# Quickly serve a directory over HTTP
serve() {
    local port="${1:-8000}"
    echo "Serving on http://localhost:$port"
    python3 -m http.server "$port"
}

# Git quick commit
gac() {
    git add .
    git commit -m "$1"
}

# Git quick commit and push
gacp() {
    git add .
    git commit -m "$1"
    git push
}

# ===========================
# Powerlevel10k Configuration
# ===========================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ===========================
# OS-specific Configuration
# ===========================

# Load OS-specific configurations
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
