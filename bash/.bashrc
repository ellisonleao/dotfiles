export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# don't put duplicate lines in the history
export HISTCONTROL=ignoreboth:erasedups
# set history length
HISTFILESIZE=1000000000
HISTSIZE=1000000

# dir colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# correct minor errors in the spelling of a directory component in a cd command
shopt -s cdspell
# save all lines of a multiple-line command in the same history entry (allows easy re-editing of multi-line commands)
shopt -s cmdhist
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# golang
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on

# fuzzy finder
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# base16 shell
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"

# load aliases
# shellcheck source=/dev/null
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# load prompt
# shellcheck source=/dev/null
[ -f ~/.bash_prompt ] && source ~/.bash_prompt

# pyenv
export EDITOR=nvim
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=~/Code
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if command -v "pyenv" &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenvwrapper" ]; then
        pyenv virtualenvwrapper_lazy
    fi
fi

# sg
if [[ -f "~/.ssh/startgrid/aliases" ]]; then
    # shellcheck source=/dev/null
    source ~/.ssh/startgrid/aliases
fi

# kitty completion
# shellcheck source=/dev/null
if command -v "kitty" &>/dev/null; then
    source <(kitty + complete setup bash)
fi

# enable bash completion
# Use bash-completion, if available
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    source /usr/share/bash-completion/bash_completion
fi

# nvm
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
