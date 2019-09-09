# Run this using 'make install' to install all dotfiles at once.
#
# This script is idempotent, meaning you can execute it even if you have already
# run it before - it will update some things, but not break.
#
# Use 'stow' directly if you only want to use some specific dotfiles.

STOWS = $(shell ls */ | sed -e 's/\/\://')

.PHONY: default
default:
	stow -S $(STOWS)
	nvim -c 'PlugUpgrade|PlugInstall|PlugUpdate|qa'
	zsh -c 'source ~/.zshrc; upgrade_oh_my_zsh'
