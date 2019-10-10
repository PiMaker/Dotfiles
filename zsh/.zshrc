# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git extract k wd fast-syntax-highlighting zsh-autosuggestions history-search-multi-word colored-man-pages_mod fancy-ctrl-z forgit undollar z fzf-z)

source $ZSH/oh-my-zsh.sh

# Theme
autoload -U promptinit; promptinit
prompt pure

# User configuration
source $HOME/.profile
export PATH="$PATH:/home/sreiter/.local/bin"

# Manually load calc plugin (allows '=' command)
source $HOME/.oh-my-zsh/plugins/calc/calc.plugin.zsh/calc.plugin.zsh

# Setup neovim as editor
export EDITOR=nvim
alias vi=vim
alias vim=nvim
alias nano=nvim

# Some aliases
alias grep='grep --ignore-case --color=auto'
alias lsn="ls -Artlh"

# To allow alias expansion in sudo commands
alias sudo='sudo '
alias please='sudo '

# Go flags
export GOROOT=/usr/local/go
export GOPATH=$HOME/Go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# "Make"/"configure" variables
export MAKEFLAGS="-j$(nproc)"

# Kitty setup
autoload -Uz compinit
compinit
kitty + complete setup zsh | source /dev/stdin

# Load local .zshrc
if [ -e "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

# Don't do auto-action when sourced for update, etc...
if [ "$FROM_SCRIPT" = "1" ]; then
    return
fi

# Auto-action when logged in to terminal 1
if [ "$(tty)" = "/dev/tty1" ]; then
    startx
else
    neofetch
    tput cuu 1
fi

