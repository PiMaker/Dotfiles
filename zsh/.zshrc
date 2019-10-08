# Path to your oh-my-zsh installation.
  export ZSH="/home/sreiter/.oh-my-zsh"

plugins=(git extract k wd fast-syntax-highlighting zsh-autosuggestions history-search-multi-word colored-man-pages_mod fancy-ctrl-z forgit undollar colorize z fzf-z)

source $ZSH/oh-my-zsh.sh

# Theme
autoload -U promptinit; promptinit
prompt pure

# User configuration
source $HOME/.profile
source $HOME/.oh-my-zsh/plugins/calc/calc.plugin.zsh/calc.plugin.zsh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR=nvim
alias vi=vim
alias vim=nvim
alias nano=nvim
alias grep='grep --ignore-case --color=auto'
alias bat='bat --tabs 8'
alias lsn="ls -Artlh"

# To allow alias expansion in sudo commands
alias sudo='sudo '
alias please='sudo '

export GOROOT=/usr/local/go
export GOPATH=$HOME/Go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export MAKEFLAGS="-j$(nproc)"

# ==== Experimental ====
#autoload -U url-quote-magic
#zle -N self-insert url-quote-magic

autoload -Uz compinit
compinit
kitty + complete setup zsh | source /dev/stdin

#export TERM=xterm-termite

# ==== END ====

if [ "$FROM_SCRIPT" = "1" ]; then
    return
fi

if [ "$(tty)" = "/dev/tty1" ]; then
    #startx
    toilet -f bigmono9 -F metal Welcome \\o/
    echo "-> startx or sway ready!"
else
    neofetch
    tput cuu 1
fi

export PATH="$PATH:/home/sreiter/.local/bin"
