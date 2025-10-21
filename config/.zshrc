export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt (should stay close to the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Core Oh My Zsh settings
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# Source split configuration files
for config_file in "$HOME/.zsh"/*.zsh; do
  source "$config_file"
done

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Powerlevel10k prompt config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
