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
        echo "Sorry, this script is intended only for Ubuntu based distros!"
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
    PACKAGE="$1"
    PROGRAM="$2"
    if [ "$PROGRAM" == "apt" ]; then
        dpkg -s "$PACKAGE" &>/dev/null
    elif [ "$PROGRAM" == "snap" ]; then
        snap list | grep "$PACKAGE" &>/dev/null
    fi
}

# --------------------------------------------------------------------
# | Main Functions                                                   |
# --------------------------------------------------------------------

create_folders() {
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/share/applications
}

configure_terminal() {
    if [[ -f "$HOME/.bashrc" ]]; then
        rm "$HOME/.bashrc"
    fi

    print_info "Configuring terminal"
    for item in "terminal nvim ui"; do
        execute "stow -R ${item}" "Creating ${item} symlink"
    done
}

configure_python() {
    print_info "Configuring python environment.."

    # pyenv prereqs
    # shellcheck disable=SC2033
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev llvm libncurses5-dev \
        libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
        python-openssl python3-dev libdbus-glib-1-dev libgirepository1.0-dev

    if [[ ! -d "$HOME/.pyenv" ]]; then
        execute "curl -fs https://pyenv.run | bash" "Installing pyenv"
    fi

    # shellcheck source=/dev/null
    source "$HOME/.bashrc"

    if ! cmd_exists "pyenv"; then
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    # virtualenvwrapper
    if [[ ! -d "$(pyenv root)/plugins/pyenv-virtualenvwrapper" ]]; then
        git clone "https://github.com/pyenv/pyenv-virtualenvwrapper.git" "$(pyenv root)/plugins/pyenv-virtualenvwrapper"
    fi

    execute "pyenv install 3.8.2" "Installing Python 3.8"
    execute "pyenv install 2.7.17" "Installing Python 2.7.17"
    execute "pyenv global 3.8.2 2.7.17" "Set global python"

    PY2=(
        flake8
        neovim
        ansible
    )

    PY3=(
        black
        flake8
        awscli
        neovim
        ipython
        docker-compose
        python-language-server
        vim-vint
        pyls-black
        dbus-python
        spotify-cli-linux
    )

    print_info "Installing python 3 packages"
    for pkg in "${PY3[@]}"; do
        pip install "$pkg" --timeout=2
    done

    print_info "Installing python 2 packages"
    for pkg in "${PY2[@]}"; do
        pip2 install "$pkg" --timeout=2
    done
}

configure_rust() {
    print_info "Installing rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # shellcheck source=/dev/null
    source "$HOME/.bashrc"

    CARGO=$(which cargo)
    if ! cmd_exists "cargo"; then
        CARGO="$HOME/.cargo/bin/cargo"
    fi

    print_info "Installing rust crates"
    RUST_CRATES=(
        'bat'
        'exa'
        'ripgrep'
        'fd-find'
        'hx'
        'licensor'
        'procs'
        'du-dust'
        'hyperfine'
        'bandwhich'
    )
    for pkg in "${RUST_CRATES[@]}"; do
        "$CARGO" install "$pkg"
    done

    # special case
    cargo install -f --git https://github.com/cjbassi/ytop ytop
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
        'npm'
        'eslint'
        'prettier'
        'bash-language-server'
        'typescript'
        'typescript-language-server'
        'vscode-html-languageserver-bin'
        '@bitwarden/cli'
        'fast-cli'
    )
    for pkg in "${NODE_PACKAGES[@]}"; do
        "$NPM" install -i "$pkg"
    done

}

configure_keys() {
    print_info "Installing Keybase"

    if [[ -f "$HOME/.ssh/id_rsa" ]]; then
        print_info "key already imported"
        return 0
    fi
    FILE="keybase_amd64.deb"

    # download keybase
    if [[ ! -f "$FILE" ]]; then
        curl --remote-name https://prerelease.keybase.io/nightly/$FILE
        execute "sudo dpkg -i $FILE" "Installing Keybase"
        sudo apt install --fix-broken
    else
        print_info "keybase file already exists, skipping download."
    fi

    # login
    keybase login

    # import private keys
    keybase pgp export -s | gpg --allow-secret-key-import --import -
    # import ssh configs
    git clone keybase://private/ellison/ssh ~/.ssh
    chmod 0400 ~/.ssh/id_rsa
    ssh-add
}

add_ppts() {
    print_info "adding additional apt sources"
    sudo apt install apt-transport-https curl

    # docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    PPTS=(
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
        "ppa:papirus/papirus"
        "ppa:mmstick76/alacritty"
        "ppa:lazygit-team/release"
    )

    for ppt in "${PPTS[@]}"; do
        sudo add-apt-repository -y "$ppt"
    done

    sudo apt-get update
    print_result $? "adding additional apt sources"
}

install_neovim() {
    print_info "Neovim"
    NPATH="$HOME/.local"
    FILENAME="nvim-linux64.tar.gz"
    # download latest nightly
    curl -fLo "$NPATH" --create-dirs \
        "https://github.com/neovim/neovim/releases/download/$VERSION/$FILENAME"

    # extract and remove tar
    tar xvf "$NPATH/$FILENAME" -C "$NPATH"
    rm "$NPATH/$FILENAME"

    # create symlinks for bin and desktop icon
    ln -fs "$NPATH/nvim-linux64/bin/nvim" "$NPATH/bin/"
    ln -fs "$NPATH/nvim-linux64/share/applications/nvim.desktop" "$NPATH/share/applications"

    # change desktop icon image path and update gnome applications db
    sed -i "s/Icon\=nvim/Icon\=\/home\/$USER\/.local\/nvim-linux64\/share\/pixmaps\/nvim.png/g" "$NPATH/share/applications/nvim.desktop"
    update-desktop-database "$NPATH/share/applications"
}

install_apps() {
    add_ppts

    print_info "Installing APT/Snap apps"

    # apt
    APT_APPS=(
        git
        curl
        stow
        hub
        wget
        fonts-firacode
        snapd
        jq
        docker-ce
        docker-ce-cli
        containerd.io
        vlc
        transmission
        gnome-tweaks
        chrome-gnome-shell
        imagemagick
        dconf-editor
        papirus-icon-theme
        alacritty
        tmux
        lua
        luarocks
        lazygit
    )
    for pkg in "${APT_APPS[@]}"; do
        execute "sudo apt-get install -y $pkg" "$pkg"
    done

    # snaps
    SNAPS=(
        spotify
        shfmt
        bitwarden
        shellcheck
        telegram-desktop
        exercism
        'go --classic'
        'shotcut --classic'
        'slack --classic'
    )

    for pkg in "${SNAPS[@]}"; do
        execute "sudo snap install $pkg" "$pkg"
    done

    install_neovim
}

configure_ui() {
    print_info "Configuring UI"
    # changing default font, themes and backgrounds
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface text-scaling-factor 0.9
    gsettings set org.gnome.desktop.interface font-name "Sans 11"
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.interface monospace-font-name "Fira Sans 13"
    gsettings set org.gnome.desktop.screensaver picture-uri "file:///home/ellison/Pictures/pathfinder-rambo.jpg"
    gsettings set org.gnome.desktop.background picture-uri "file:///home/ellison/Pictures/ellie.jpeg"

    # custom keyboard bindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>c']"

    # media keys bindings
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "['<Alt>p']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Spotify Play/Pause"

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "['<Alt>Right']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "Spotify Next"

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "['<Alt>Left']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Spotify Previous'

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
    verify_os

    ask_for_sudo

    create_folders

    configure_keys

    install_apps

    configure_terminal

    configure_python

    configure_rust

    configure_node

    configure_ui

    echo "Success! Please restart the terminal to see the changes!"
}

main
