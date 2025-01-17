#!/usr/bin/env bash
ZSH_CUSTOM="$HOME/.zsh"

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
  ln -sf $PWD/$dotfile $HOME/$dotfile
done

apt install zsh fzf
chsh -s $(which zsh)
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt install -y neovim ripgrep fd-find

mkdir luals
wget https://github.com/LuaLS/lua-language-server/releases/download/3.12.0/lua-language-server-3.12.0-linux-x64.tar.gz
mv lua-language-server-3.12.0-linux-x64.tar.gz luals
tar xzf /luals/lua-language-server-3.12.0-linux-x64.tar.gz -C luals

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
