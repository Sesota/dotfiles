#!/usr/bin/env bash

set -e

dotfiles=(
  .config/nvim/init.lua
  .gitconfig
  .tmux.conf
  .zshrc
  .zsh_theme.sh
  .fzf.zsh
  .proxychains/proxychains.conf
)

# Symlink all dotfiles listed above to the right spot
for dotfile in ${dotfiles[@]}; do
  rm -f $HOME/$dotfile
  mkdir -p $(dirname $HOME/$dotfile)
  ln -f $PWD/$dotfile $HOME/$dotfile
done

apt install zsh
chsh -s $(which zsh)
zsh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
