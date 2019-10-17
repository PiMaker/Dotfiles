set -e

cd ~/.oh-my-zsh/custom/plugins

REPOS=(
        "https://github.com/arzzen/calc.plugin.zsh"
        "https://github.com/zuxfoucault/colored-man-pages_mod"
        "https://github.com/zpm-zsh/colorize"
        "https://github.com/zdharma/fast-syntax-highlighting"
        "https://github.com/wfxr/forgit"
        "https://github.com/andrewferrier/fzf-z"
        "https://github.com/zdharma/history-search-multi-word"
        "https://github.com/supercrabtree/k"
        "https://github.com/zpm-zsh/undollar"
        "https://github.com/zsh-users/zsh-autosuggestions"
)

for x in $REPOS; do
        dir=$(echo "$x" | sed 's/.*\///g')
        if [ ! -d "$dir" ]; then
                echo "Plugin $dir not found, cloning from GitGub!"
                git clone --recursive $x
                echo "=> Download complete!"
        else
                echo "Plugin $dir found!"
        fi
done
