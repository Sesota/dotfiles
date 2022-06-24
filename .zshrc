# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# ZPlug
source "$HOME/.zplug/init.zsh"

zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/zsh-autosuggestions", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "junegunn/fzf", use:"shell/{key-bindings,completion}.zsh"
zplug "peco/peco", as:command, from:gh-r

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# -----------------------------------------------------------------------------

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ethica-admin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# -----------------------------------------------------------------------------

# Oh-My-Zsh!
export ZSH=$HOME/.zplug/repos/robbyrussell/oh-my-zsh

ZSH_CUSTOM="$HOME/.zsh"
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true
# DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_THEME='af-magic'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

source $ZSH/oh-my-zsh.sh

autoload -U zmv

# -----------------------------------------------------------------------------

# FZF
source "$HOME/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh"
source "$HOME/.zplug/repos/junegunn/fzf/shell/completion.zsh"
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# -----------------------------------------------------------------------------

# Aliases
alias ssh="TERM=xterm-256color ssh"
alias ll="ls -lha"
alias v="nvim"
alias confedit="nvim ~/dotfiles"

act () {
  source ".venv/bin/activate"
  export $(grep -v '^#' ${1:-.env} | xargs -d '\n')
}

# -----------------------------------------------------------------------------

# Other environment variables
# Compilation flags

export EDITOR='nvim'

# -----------------------------------------------------------------------------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh_theme.sh ] && source ~/.zsh_theme.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
