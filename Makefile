# Run this using 'make' to install all dotfiles at once.
#
# This script is idempotent, meaning you can execute it even if you have already
# run it before - it will update some things, but not break.
#
# Use 'stow' directly if you only want to use some specific dotfiles.

STOWS = $(shell ls */ | sed -e 's/\/\://')
PURE_DIR = $(HOME)/.zsh/pure

.PHONY: default nvim stow zsh-plugins allow-remote-clip-locally

default: nvim zsh-plugins

stow:
	stow -v -S $(STOWS)

nvim: stow
	# auto-install and upgrade vim-plug plugins
	nvim -Es -u $(HOME)/.config/nvim/init.vim -c PlugInstall -c PlugUpgrade -c PlugUpdate -c qa

zsh-plugins: stow
	zsh ./install-zsh-plugins.zsh
	zsh ./upgrade-zsh-plugins.zsh

	# install pure theme
	mkdir -p $(HOME)/.zsh
	[ -d "$(PURE_DIR)" ] || \
		git clone https://github.com/sindresorhus/pure.git \
		$(PURE_DIR)
	cd $(PURE_DIR) && (git status || (git checkout -b $(shell date +"%d-%m-%Y_%H-%M-%S") && \
		git commit -a -m "backup-commit")) && \
		git checkout master && git reset --hard HEAD && \
		git pull --rebase
	chmod -R a+rx $(PURE_DIR)
	chmod a+rx $(PURE_DIR)

allow-remote-clip-locally:
	[[ $$(whoami) == "remote-clip-access" ]] || (echo "ERROR: This has to be run as dedicated user 'remote-clip-access' for security reasons!" && exit 1)
	mkdir -p ~/.ssh && umask 0077 && touch ~/.ssh/authorized_keys
	grep "remote-clip-access" ~/.ssh/authorized_keys >/dev/null || ( \
		echo -n 'command="DISPLAY=:0 /usr/bin/xclip -selection clipboard; echo success",no-port-forwarding,no-x11-forwarding,no-agent-forwarding ' >> ~/.ssh/authorized_keys && \
		cat neovim/.config/nvim/remote-clip.key.pub >> ~/.ssh/authorized_keys )
	@echo "IMPORTANT: Don't forget to allow this user ($$(whoami)) to access your X session!"
	@echo "IMPORTANT: I.e. run 'xhost +SI:localuser:remote-clip-access' as the owner of your session at X startup!"

