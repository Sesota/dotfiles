#!/usr/bin/env bash

set -e

dotfiles=(
  .config/nvim/init.lua
  .gitconfig
  .tmux.conf
  .zshrc
  .zsh_theme.sh
)

# Symlink all dotfiles listed above to the right spot
for dotfile in ${dotfiles[@]}; do
  rm -f $HOME/$dotfile
  mkdir -p $(dirname $HOME/$dotfile)
  ln -sf $PWD/$dotfile $HOME/$dotfile
done
