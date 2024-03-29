# Sepehr's Dotfiles

## Install

`git clone https://github.com/Sesota/dotfiles.git ~/dotfiles-sepehr`

### Quick install

- change DOTFILESDIR in zshrc  # TODO make it as part of the script
- run `./install.sh`
- `chsh -s $(which zsh)`
- run p10k

#### General packages
- proxychains
- neovim
- tmux
- fzf
- dnscrypt
- chrome
- make
- zsh-theme-powerlevel10k-git
- visual-studo-code-bin
- tailscale
- geoip
- telegram
- Spotify
- poetry
- discord
- steam
- thunderbird
- XDM
- [Jetbrains Font](https://www.jetbrains.com/lp/mono/)
- playerctl
- docker
- v2raya
- ripgrep

#### settings
- autostart:
  - yakuake
- enable aur/flatpak support on pamac

#### Files to share
- passwords.json
- .zhistory

#### neovim
- Run `:PackerInstall`

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
