#!/bin/bash

#######
# zsh #
#######
ln -sf "$HOME/dotfiles/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/zshenv" "$HOME/.zshenv"
rm -rf "$HOME/.zsh"
ln -s "$HOME/dotfiles/zsh" "$HOME/.zsh"

#######
# vim #
#######
rm -rf "$HOME/.vim"
ln -s "$HOME/dotfiles/vim" "$HOME/.vim"
ln -sf "$HOME/dotfiles/vimrc" "$HOME/.vimrc"

########
# nvim #
########
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/undo"
ln -sf "$HOME/dotfiles/nvim/init.vim" "$HOME/.config/nvim"

#######
# X11 #
#######
rm -rf "$HOME/.config/X11"
ln -s "$HOME/dotfiles/X11" "$HOME/.config"

######
# i3 #
######
rm -rf "$HOME/.config/i3"
ln -s "$HOME/dotfiles/i3" "$HOME/.config"

