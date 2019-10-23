# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Fix annoying error when running as root
ZSH_DISABLE_COMPFIX="true"

plugins=(git extract k wd fast-syntax-highlighting zsh-autosuggestions history-search-multi-word colored-man-pages fancy-ctrl-z forgit undollar z fzf-z)

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
zstyle ':completion:*' special-dirs false

# Manually load calc plugin (allows '=' command)
source $HOME/.oh-my-zsh/custom/plugins/calc.plugin.zsh/calc.plugin.zsh

# Setup neovim as editor
export EDITOR=nvim
alias vi=vim
alias vim=nvim
alias nano=nvim

# Some aliases
alias grep='grep --ignore-case --color=auto'
alias lsn='ls -Artlh'
alias ccat='bat -p'
alias lsnl="ls -Art | tail -n1"
alias fxargs='find -type f -print0 | xargs -0 -n 1 -P 0'
alias zshnohist='env HISTFILE="/dev/null" zsh'

# To allow alias expansion in sudo commands
alias sudo='sudo '
alias please='sudo '

# Custom functions
function locate() {
  sudo find / -iname "$1" 2>&1 | grep -v "Permission denied"
}

function blank_screen() {
  xset dpms force off
  read
  xset s off; xset -dpms
}

function killjobs() {

    local kill_list="$(jobs)"
    if [ -n "$kill_list" ]; then
        # this runs the shell builtin kill, not unix kill, otherwise jobspecs cannot be killed
        # the `$@` list must not be quoted to allow one to pass any number parameters into the kill
        # the kill list must not be quoted to allow the shell builtin kill to recognise them as jobspec parameters
        kill $@ $(sed --regexp-extended --quiet 's/\[([[:digit:]]+)\].*/%\1/gp' <<< "$kill_list" | tr '\n' ' ')
    else
        return 0
    fi

}

function kpatch () {
  patch=$1
  shift
  git send-email \
    --cc-cmd="./scripts/get_maintainer.pl --norolestats $patch" \
    $@ $patch
}

# Go flags
export GOROOT=/usr/local/go
export GOPATH=$HOME/Go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

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

# Load local .zshrc
if [ -e "$HOME/.zshrc_local" ]; then
    source $HOME/.zshrc_local
fi

# Don't do auto-action when sourced for update, etc...
if [ "$FROM_SCRIPT" = "1" ]; then
    return
fi

# Auto-action when logged in to terminal 1
if [[ "$(tty)" = "/dev/tty1" && ! -f "/tmp/tty1startx.done" ]]; then
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

