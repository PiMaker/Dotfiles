# Run this using 'make' to install all dotfiles at once.
#
# This script is idempotent, meaning you can execute it even if you have already
# run it before - it will update some things, but not break.
#
# Use 'stow' directly if you only want to use some specific dotfiles.

STOWS = $(shell ls */ | sed -e 's/\/\://')

.PHONY: default nvim stow zsh-plugins

default: nvim zsh-plugins

stow:
	stow -v -S $(STOWS)

nvim: stow
	nvim -c 'PlugUpgrade|PlugInstall|PlugUpdate|qa'

zsh-plugins: stow
	zsh ./install-zsh-plugins.zsh
	zsh ./upgrade-zsh-plugins.zsh
