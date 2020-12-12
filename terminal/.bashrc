# shellcheck source=/dev/null
source ~/.exports

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

# load aliases
# shellcheck source=/dev/null
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# load prompt
# shellcheck source=/dev/null
[[ -f "$HOME/.bash_prompt" ]] && source "$HOME/.bash_prompt"


if command -v "pyenv" &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenvwrapper" ]; then
        pyenv virtualenvwrapper_lazy
    fi
fi

# sg
# shellcheck source=/dev/null
[[ -f "$HOME/.ssh/startgrid/aliases" ]] && source "$HOME/.ssh/startgrid/aliases"

# enable bash completion
# Use bash-completion, if available
# shellcheck source=/dev/null
[[ -f "/usr/share/bash-completion/bash_completion" ]] && source /usr/share/bash-completion/bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
