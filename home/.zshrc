export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(bun colored-man-pages command-not-found eza fancy-ctrl-z git sudo vi-mode zoxide zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

zellij-clear() { zellij action clear; zle reset-prompt; }
zle -N zellij-clear
bindkey '^K' zellij-clear

eval "$(zoxide init zsh)"

# Homebrew — detect install path per OS/architecture
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"               # macOS (Apple Silicon)
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"                  # macOS (Intel)
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linux
fi

alias vim='nvim'

# Clipboard — macOS provides pbcopy/pbpaste natively; emulate on Linux via xclip
if [[ "$OSTYPE" != darwin* ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# Machine-specific overrides (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
