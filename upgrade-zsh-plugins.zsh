set -e

export FROM_SCRIPT=1
source ~/.zshrc
cd $ZSH/custom/plugins

for x in *; do
    echo "=> Entering: $x"
    cd $x
    if git status; then
        git pull -q --ff-only || true
    else
        echo "Not a git repo!"
    fi
    cd ..
done
