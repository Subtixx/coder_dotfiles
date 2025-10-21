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

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias c="clear"
alias md="mkdir -p"
alias rd="rmdir"
alias cpv="cp -v"
alias mvv="mv -v"
alias rmf="rm -rf"

# Network utilities
alias ports="netstat -tulanp"

# Process management
alias psg="ps aux | grep -v grep | grep -i"
alias k9="kill -9"

# Archive extraction
alias untar="tar -xvf"
alias untargz="tar -xzvf"
alias untarbz2="tar -xjvf"
alias unzipall="find . -name '*.zip' -exec unzip {} ;"

# Misc
alias please="sudo"
alias histg="history | grep"
alias dfh="df -h"
alias duh="du -h --max-depth=1"
alias path='echo -e ${PATH//:/\n}'

# System update/cleanup (OS-aware)
update-system() {
    if command -v pacman > /dev/null 2>&1; then
        sudo pacman -Syu
    elif command -v apt > /dev/null 2>&1; then
        sudo apt update && sudo apt upgrade -y
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf upgrade --refresh -y
    elif command -v zypper > /dev/null 2>&1; then
        sudo zypper refresh && sudo zypper update -y
    elif command -v apk > /dev/null 2>&1; then
        sudo apk update && sudo apk upgrade
    else
        echo "No supported package manager found."
        return 1
    fi
}

cleanup() {
    if command -v pacman > /dev/null 2>&1; then
        sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null
    elif command -v apt > /dev/null 2>&1; then
        sudo apt autoremove -y
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf autoremove -y
    elif command -v zypper > /dev/null 2>&1; then
        sudo zypper packages --orphaned | awk '/orphaned/ {print $3}' | xargs -r sudo zypper remove
    elif command -v apk > /dev/null 2>&1; then
        sudo apk cache clean
    else
        echo "No supported package manager found."
        return 1
    fi
}
