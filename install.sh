#!/bin/bash
# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------
print_error() {
	printf "\\e[0;31m%s\\e[0m\\n" " [ ✖ ] $1 $2"
}

print_info() {
	printf "\\e[0;35m%s\\e[0m\\n" "$1"
}

print_result() {
	if [ "$1" -eq 0 ]; then
		printf "\\e[0;32m%s\\e[0m\\n" " [ ✔ ] $2"
	else
		print_error "$2"
	fi

	return "$1"
}

ask_for_sudo() {
	sudo -v &>/dev/null
	# Update existing `sudo` time stamp until this script has finished
	# https://gist.github.com/cowboy/3118588
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done &>/dev/null &

}

verify_os() {
	if [ ! "$(uname -s)" == "Linux" ]; then
		echo "Sorry, this script is intended only for Arch based distros!"
		exit 1
	fi
}

show_spinner() {
	local -r FRAMES='/-\|'
	# shellcheck disable=SC2034
	local -r NUMBER_OR_FRAMES=${#FRAMES}
	local -r CMDS="$2"
	local -r MSG="$3"
	local -r PID="$1"
	local i=0
	local frameText=""

	# Display spinner while the commands are being executed.
	while kill -0 "$PID" &>/dev/null; do
		frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
		printf "%s" "$frameText"
		sleep 0.2
		printf "\\r"
	done
}

set_trap() {
	trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"
}

execute() {
	local -r CMDS="$1"
	local -r MSG="${2:-$1}"
	local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
	local exitCode=0
	local cmdsPID=""

	# If the current process is ended,
	# also end all its subprocesses.
	set_trap "EXIT" "kill_all_subprocesses"

	# Execute commands in background
	eval "$CMDS" \
		&>/dev/null \
		2>"$TMP_FILE" &

	cmdsPID=$!

	show_spinner "$cmdsPID" "$CMDS" "$MSG"
	wait "$cmdsPID" &>/dev/null
	exitCode=$?
	print_result $exitCode "$MSG"

	if [ $exitCode -ne 0 ]; then
		print_error_stream <"$TMP_FILE"
	fi

	rm -rf "$TMP_FILE"
	return $exitCode
}

print_error_stream() {
	while read -r line; do
		print_error "↳ ERROR: $line"
	done
}

cmd_exists() {
	command -v "$1" &>/dev/null
	return $?
}

package_is_installed() {
	pacman -Qi "$PACKAGE" &>/dev/null
}

# --------------------------------------------------------------------
# | Main Functions                                                   |
# --------------------------------------------------------------------

configure_terminal() {
	if [[ -f "$HOME/.bashrc" ]]; then
		rm "$HOME/.bashrc"
		rm "$HOME/.bash_profile"
	fi

	print_info "Configuring terminal"
	for item in "configs terminal ui"; do
		execute "stow -R ${item}" "Creating ${item} symlink"
	done
}

configure_python() {
	print_info "Configuring python environment.."

	yay -S python-pip python

	PKGS=(
		black
		neovim
		ptipython
		httpie
	)

	print_info "Installing python 3 packages"
	for pkg in "${PKGS[@]}"; do
		pip install "$pkg" --timeout=2
	done

}

configure_node() {
	NPM=$(which npm)
	if ! cmd_exists "n"; then
		execute "curl -L https://git.io/n-install | N_PREFIX=~/.local/n bash -s -- -y -n" "Installing n"
		NPM="$HOME/.local/n/bin/npm"
	fi

	# shellcheck source=/dev/null
	source "$HOME/.bashrc"

	print_info "Installing node packages"
	NODE_PACKAGES=(
		prettier
		typescript
		fast-cli
	)
	for pkg in "${NODE_PACKAGES[@]}"; do
		"$NPM" install -i "$pkg"
	done

}

install_apps() {

	print_info "Installing apps"

	APPS=(
		alacritty
		aws-cli
		bandwhich
		bash-completion
		bat
		chrome-gnome-shell
		discord
		docker
		docker-compose
		dust
		exercism-bin
		fd
		figlet
		git-delta
		github-cli
		gnome-calendar
		go
		google-chrome
		google-cloud-sdk
		guvcview
		hub
		hyperfine
		jq
		lolcat
		lua-busted
		neofetch
		neovim-nightly-bin
		nerd-fonts-jetbrains-mono
		obs-studio
		pritunl-client-electron
		python-pip
		ripgrep
		rtl88xxau-aircrack-dkms-git
		shfmt-bin
		slack-desktop
		spotify
		stow
		stylua
		telegram-desktop
		tldr
		tmux
		transmission-gtk
		vlc
	)

	for pkg in "${APT_APPS[@]}"; do
		if ! package_is_installed "$pkg"; then
			execute "yay -S $pkg" "$pkg"
		fi
	done
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	verify_os

	ask_for_sudo

	install_apps

	configure_terminal

	configure_python

	configure_node

	echo "Success! Please restart the terminal to see the changes!"
}

main
