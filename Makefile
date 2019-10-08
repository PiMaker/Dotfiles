# Run this using 'make' to install all dotfiles at once.
#
# This script is idempotent, meaning you can execute it even if you have already
# run it before - it will update some things, but not break.
#
# Use 'stow' directly if you only want to use some specific dotfiles.

STOWS = $(shell ls */ | sed -e 's/\/\://')

.PHONY: default nvim stow zsh

default: nvim stow zsh

stow:
	stow -S $(STOWS)

nvim:
	nvim -c 'PlugUpgrade|PlugInstall|PlugUpdate|qa'

zsh: zsh-plugins
	zsh -c 'export FROM_SCRIPT=1; source ~/.zshrc; upgrade_oh_my_zsh'

zsh-plugins:
	zsh ./upgrade-zsh-plugins.zsh
