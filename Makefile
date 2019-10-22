# Run this using 'make' to install all dotfiles at once.
#
# This script is idempotent, meaning you can execute it even if you have already
# run it before - it will update some things, but not break.
#
# Use 'stow' directly if you only want to use some specific dotfiles.

STOWS = $(shell ls */ | sed -e 's/\/\://')
PURE_DIR = $(HOME)/.zsh/pure

.PHONY: default nvim stow zsh-plugins

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
