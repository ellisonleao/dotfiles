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
shopt -s nocaseglob;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

export PATH=/usr/local/share/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/opt/go/libexec/bin
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
ssh-add ~/.ssh/id_rsa
export EDITOR=vim
eval "$(hub alias -s)"

# unset this because of nasty OS X bug with annoying message:
# "dyld: DYLD_ environment variables being ignored because main executable (/usr/bin/sudo) is setuid or setgid"
# this is not correct, but Apple is too lazy to fix this
unset DYLD_LIBRARY_PATH


export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

alias rake='noglob rake'
alias gup='git-up'


if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# setup color variables
color_is_on=
color_red=
color_green=
color_yellow=
color_blue=
color_white=
color_gray=
color_bg_red=
color_off=
color_user=
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_is_on=true
	color_black="\[$(/usr/bin/tput setaf 0)\]"
	color_red="\[$(/usr/bin/tput setaf 1)\]"
	color_green="\[$(/usr/bin/tput setaf 2)\]"
	color_yellow="\[$(/usr/bin/tput setaf 3)\]"
	color_blue="\[$(/usr/bin/tput setaf 6)\]"
	color_white="\[$(/usr/bin/tput setaf 7)\]"
	color_gray="\[$(/usr/bin/tput setaf 8)\]"
	color_off="\[$(/usr/bin/tput sgr0)\]"

	color_error="$(/usr/bin/tput setab 1)$(/usr/bin/tput setaf 7)"
	color_error_off="$(/usr/bin/tput sgr0)"

	# set user color
	case `id -u` in
		0) color_user=$color_red ;;
		*) color_user=$color_green ;;
	esac
fi

# User color
case $(id -u) in
	0) user_color="$color_red" ;;  # root
	*) user_color="$color_green" ;;
esac

# Symbols
prompt_symbol="❯"
prompt_clean_symbol=""
prompt_dirty_symbol="*"

function prompt_command() {
	# Local or SSH session?
	local remote=
	[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && remote=1

	# Git branch name and work tree status (only when we are inside Git working tree)
	local git_prompt=
	if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
		# Branch name
		local branch="$(git symbolic-ref HEAD 2>/dev/null)"
		branch="${branch##refs/heads/}"

		# Working tree status (red when dirty)
		local dirty=
		# Modified files
		git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
		# Untracked files
		[ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1

		# Format Git info
		if [ -n "$dirty" ]; then
			git_prompt=" $color_red$prompt_dirty_symbol$branch$color_off"
		else
			git_prompt=" $color_green$prompt_clean_symbol$branch$color_off"
		fi
	fi

	# Virtualenv
	local venv_prompt=
	if [ -n "$VIRTUAL_ENV" ]; then
		venv_prompt=" ($color_blue$(basename $VIRTUAL_ENV))"
	fi

	# Format prompt
	first_line="$venv_prompt$color_white\w$color_off$git_prompt"
	PS1="${first_line}\n${color_green}${prompt_symbol}${color_off} "

	# Terminal title
	local title="$(basename "$PWD")"
	[ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
	echo -ne "\033]0;$title"; echo -ne "\007"
}

# Show awesome prompt only if Git is istalled
command -v git >/dev/null 2>&1 && PROMPT_COMMAND=prompt_command

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Visual studio code alias
visu () {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
        open -a "Visual Studio Code" --args "$F"
    fi
}

# Bash aliases
if [ -f ~/.bash_aliases ]; then
	source ~/.bash_aliases
fi

# osx configs
if [ -f ~/.osx ]; then
	source ~/.osx
fi

# Go
export GOPATH=~/Code/go
export PATH="$PATH:$GOPATH/bin"
