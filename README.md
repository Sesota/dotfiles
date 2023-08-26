# Sepehr's Dotfiles

## Install

`git clone https://github.com/Sesota/dotfiles.git ~/dotfiles-sepehr`

### Quick install

- run `./install.sh`

### Install tmux
#### Build prerequisites
- ubuntu
  `sudo apt-get install libevent-dev ncurses-dev build-essential bison pkg-config automake`
- RHEL
  `sudo yum -y install libevent-devel ncurses-devel gcc make bison pkg-config`

#### Building
- `git clone https://github.com/tmux/tmux.git`
- `cd tmux && sh autogen.sh`
- `./configure`
- `make && sudo make install`

### Install Neovim

#### Build prerequisites

- ubuntu
  `sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen`
- RHEL
  `sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl`

#### Building
- `git clone https://github.com/neovim/neovim`
- `cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo`
- ` sudo make install`
- `cd .. && rm -rf neovim`

## TODO

### `General`

- ! unify the custom-dotfiles/.zshrc and .zshrc
- vim-surround how to wrap?
- https://toroid.org/modern-neovim
- other vscode functionalities to port (to avoid consuming time when doing tasks)
  - markdown
- Install script
  - README curl install.sh
  - Install all deps (build the ones necessary)
  - clone the dotfiles
  - make backup of existing dotfiles
  - replace them all
  - install all deps plugins. Init nvim, zsh, fzf, **RIPGREP**, fd, etc.

### `init.lua`

- breadcrumbs
- git thingies
- tmux italic alt

### General packages
- proxychains
- neovim
- tmux
- fzf
- dnscrypt
- chrome

### settings
- autostart:
  - yakuake
- enable aur/flatpak support on pamac


