# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export DISABLE_AUTO_UPDATE=true

# Fix annoying error when running as root
ZSH_DISABLE_COMPFIX="true"

plugins=(git extract k wd fast-syntax-highlighting zsh-autosuggestions history-search-multi-word colored-man-pages fancy-ctrl-z forgit undollar z fzf-z warhol calc zsh_reload)

source $ZSH/oh-my-zsh.sh

# Theme
fpath+=("$HOME/.zsh/pure")
autoload -U promptinit; promptinit
prompt pure

# User configuration
[ -f $HOME/.profile ] && source $HOME/.profile
export PATH="$PATH:/home/sreiter/.local/bin"

setopt histignorespace
setopt globdots
setopt -K # avoid treating ! specially
zstyle ':completion:*' special-dirs false

# Load custom scripts
fpath=(~/.config/zsh "${fpath[@]}")
autoload -Uz locate blank_screen killjobs kp ks kpatch nanowd
nanowd # I don't understand autoload

# Setup neovim as editor
export EDITOR=nvim
alias vi=vim
alias vim=nvim
alias nano=nvim

# The flesh is weak
alias c=cd
alias n=nano

# Some aliases
alias grep='grep --ignore-case --color=auto'
alias lsn='ls -Artlh'
alias ccat='bat -p'
alias lsnl="ls -Art | tail -n1"
alias fxargs='find -type f -print0 | xargs -0 -n 1 -P 0'
alias zshnohist='env HISTFILE="/dev/null" zsh'
alias rtfm=man

# To allow alias expansion in sudo commands and provide zsudo to run zsh
# functions as root
alias sudo='sudo '
alias please='sudo '
alias sudop='sudo ' # I'm stupid, sorry
zsudo() sudo zsh -c "$functions[$1]" "$@"

# Compilation flags
export CONCURRENCY_LEVEL="$(nproc)"
export MAKEFLAGS="-j$(nproc)"

# Better paste behaviour
# (no url-quote-magic for now, since it breaks syntax highlighting)
# autoload -Uz url-quote-magic
# zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
zstyle :bracketed-paste-magic paste-init backward-extend-paste

# Kitty setup
if [ "$TERM" = "xterm-kitty" ]; then
    autoload -Uz compinit
    compinit
    kitty + complete setup zsh | source /dev/stdin
fi

# Termite setup
if [[ $TERM == xterm-termite && -f /etc/profile.d/vte.sh ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# Load local .zshrc
if [ -e "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

# Don't do auto-action when sourced for update, etc...
if [ "$FROM_SCRIPT" = "1" ]; then
    return
fi

# Auto-action when logged in to terminal 1 (on system with X installed)
if command -v startx > /dev/null && \
    [[ "$(tty)" = "/dev/tty1" && ! -f "/tmp/tty1startx.done" ]]; then
    touch "/tmp/tty1startx.done"
    startx
else
    # Print status if not launched as nested shell
    # This avoids printing neofetch when running 'sudo -i' for example
    PARENT_PID=$(ps -p "$$" -o ppid= | tr -d " ")
    PARENT_EXECUTABLE=$(cat /proc/$PARENT_PID/comm)
    if [ "$PARENT_EXECUTABLE" != "zsh" ]; then
        # Check for sudo
        if [[ "$SUDO_COMMAND" != "$(which su)" && "$SUDO_COMMAND" != "$SHELL" ]]; then
            # Check for SSH
            if [[ -v SSH_CONNECTION ]]; then
                SRC=$(echo "$SSH_CONNECTION" | cut -d' ' -f1,2 | tr " " ":")
                DST=$(echo "$SSH_CONNECTION" | cut -d' ' -f3,4 | tr " " ":")
                echo
                echo "Incoming SSH: $SRC -> $DST"
            else
                neofetch
                tput cuu 1
            fi
        fi
    fi
fi

