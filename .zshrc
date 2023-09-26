# RC variables
DOTFILESDIR=$HOME/dotfiles

# Check if zplug is installed
if [[ ! -d $HOME/.zplug ]]; then
  git clone https://github.com/zplug/zplug $HOME/.zplug
  source $HOME/.zplug/init.zsh && zplug update --self
fi

# ZPlug
source "$HOME/.zplug/init.zsh"

zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/zsh-autosuggestions", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "junegunn/fzf", use:"shell/{key-bindings,completion}.zsh"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# -----------------------------------------------------------------------------

# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.histfile
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
# Tmux

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_CONFIG=$DOTFILESDIR/.tmux.conf
ZSH_TMUX_DEFAULT_SESSION_NAME=sesota

# -----------------------------------------------------------------------------

# Oh-My-Zsh!
export ZSH=$HOME/.zplug/repos/robbyrussell/oh-my-zsh

ZSH_CUSTOM="$HOME/.zsh"
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true
# DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_THEME='af-magic'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

plugins=(
  git
  tmux
)
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
alias confedit="nvim $DOTFILESDIR"
alias tm="tmux -L sepehr -f $DOTFILESDIR/.tmux.conf"
alias antlr4="antlr4-7"
alias antlr4-7="java -jar /usr/local/lib/antlr-4.7.2-complete.jar"
alias antlr4-12="java -jar /usr/local/lib/antlr-4.12.0-complete.jar"
alias grun="java org.antlr.v4.gui.TestRig"
export CLASSPATH=".:/usr/local/lib/antlr-4.7.2-complete.jar:$CLASSPATH"

act () {
  source ".venv/bin/activate"
  export $(grep -v '^#' ${1:-.env} | xargs -d '\n')
}

gpass () {
  cat ~/gpass | wl-copy
}

# Auto active virtual environment with name of .venv
function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the vitualenv
      if [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
      fi
      if [[ -f ./webserver.sepehr.env ]]; then
        export $(cut -d= -f1 <(cat webserver.sepehr.env | grep -Ev "^$|^#"))
      fi
      if [[ -f ./.env ]]; then
        export $(cut -d= -f1 <(cat .env | grep -Ev "^$|^#"))
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
        if [[ -f $parentdir/.env ]]; then
          unset $(cut -d= -f1 < $parentdir/.env)
        fi
        if [[ -f $parentdir/webserver.sepehr.env ]]; then
          unset $(cut -d= -f1 < $parentdir/webserver.sepehr.env)
        fi
      fi
  fi
}

# -----------------------------------------------------------------------------

# Other environment variables
# Compilation flags

export EDITOR='nvim'

# -----------------------------------------------------------------------------

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# [ -f $DOTFILESDIR/.zsh_theme.sh ] && source $DOTFILESDIR/.zsh_theme.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
