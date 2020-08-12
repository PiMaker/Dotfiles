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

setopt histignorespace
setopt globdots
setopt -K # avoid treating ! specially
zstyle ':completion:*' special-dirs false

# Load custom scripts
fpath=(~/.config/zsh "${fpath[@]}")
autoload -Uz locate blank_screen killjobs kp ks kpatch nanowd
nanowd # I don't understand autoload

autoload edit-command-line; zle -N edit-command-line
function edit-command-line-custom() {
    if [ -z "$BUFFER" ]; then
        BUFFER=$(history | tail -n1 | cut -d" " -f3-)
    fi
    zle edit-command-line
}
zle -N edit-command-line-custom
bindkey '^e' edit-command-line-custom

function ctrlp() {
    local in_cmd="command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"
    local f=$(eval "$in_cmd" | fzf --preview '([[ -d {} ]] && ls -lA --color=always {}) || head -n50 {} | bat --color always --style=numbers,changes --wrap never -l $(basename -- {} | perl -pe "s/.*\.//")' --preview-window='top:50%' --ansi)
    if [ -z "$f" ]; then
        zle redisplay
        return 0
    fi

    if [[ -d "$f" ]]; then
        BUFFER="$f"
    elif [[ -e "$f" ]]; then
        BUFFER="nvim $f"
    else
        return 1
    fi

    zle accept-line
}
zle -N ctrlp
bindkey '^p' ctrlp

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
alias xclip='xclip -selection clipboard'
alias atop2='echo "i2\nt" | atop'

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
if [[ "${VTE_VERSION:-0}" -ge 3405 && -f /etc/profile.d/vte.sh ]]; then
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
        else
            # we're sudo'ed to someone else, force display username
            prompt_pure_state[username]='%F{$prompt_pure_colors[user]}%n%f%F{$prompt_pure_colors[host]}@%m%f'
        fi
    fi
fi

