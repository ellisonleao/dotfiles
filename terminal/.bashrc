#!/bin/bash
# load env vars exports
# shellcheck source=/dev/null
[[ -f "$HOME/.exports" ]] && source "$HOME/.exports"

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

# enable bash completion
# Use bash-completion, if available
# shellcheck source=/dev/null
[[ -f "/usr/share/bash-completion/bash_completion" ]] && source /usr/share/bash-completion/bash_completion

# load starship prompt
if command -v starship &>/dev/null; then
	eval "$(starship init bash)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
	export _ZO_DATA=${HOME}/.cache/zoxide
	export _ZO_ECHO=1

	eval "$(zoxide init bash)"
fi
