#!/bin/bash

BRANCH="${1-linux}"
DOTFILES_ORIGIN="https://github.com/ellisonleao/dotfiles.git"
DOTFILES_REPO_DIR="$HOME/dotfiles"

# shellcheck source=/dev/null
source ./helpers.sh

# --------------------------------------------------------------------
# | Main Functions                                                   |
# --------------------------------------------------------------------

configure_terminal() {
    print_info "Configuring terminal"
    FOLDERS="base16 bash git nvim python kitty gnupg ui prettier"
    for item in $FOLDERS; do
        execute "stow ${item}" "Creating ${item} symlink"
    done
}

clone_dotfiles() {
    if [ -d "$DOTFILES_REPO_DIR" ]; then
        print_info "Dotfiles folder already exists.. skipping"
        return 0
    fi
    # Cloning dotfiles on directory
    execute "git clone $DOTFILES_ORIGIN $DOTFILES_REPO_DIR --recursive --branch=$BRANCH" "Cloning dotfiles on $DOTFILES_REPO_DIR branch=$BRANCH"
}

configure_python() {
    print_info "Configuring python environment.."

    if [ -d "$HOME/.pyenv" ]; then
        print_info "$HOME/.pyenv folder already exists. please remove it and try again"
        return 1
    fi

    # pyenv prereqs
    # shellcheck disable=SC2033
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

    execute "curl https://pyenv.run | bash" "Installing pyenv"

    # reload terminal configs
    # shellcheck source=/dev/null
    source "$HOME/.bashrc"

    if ! cmd_exists "pyenv"; then
        print_error "pyenv could not be installed. Moving on"
        return 1
    fi

    # virtualenvwrapper
    execute "git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper"

    execute "pyenv install 3.7.4" "Installing Python 3.7.4"
    execute "pyenv install 2.7.15" "Installing Python 2.7.15"

    pyenv global 3.7.4 2.7.15

    PY2=(
        pylint
        neovim
        ansible
    )

    PY3=(
        pylint
        awscli
        neovim
        ipython
        youtube-dl
        docker-compose
        black
        python-language-server
        jedi
    )

    print_info "Installing python 3 packages"
    for pkg in "${PY3[@]}"; do
        pip install "$pkg"
    done

    print_info "Installing python 2 packages"
    pyenv activate 2
    for pkg in "${PY2[@]}"; do
        pip2 install "$pkg"
    done
}

configure_node() {
    unset NVM_DIR
    if [ -d "$HOME/.nvm" ]; then
        print_info "$HOME/.nvm folder exists, please remove it and try again"
        return 1
    fi

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

    # shellcheck source=/dev/null
    source "$HOME/.bashrc"
    if ! cmd_exists "nvm"; then
        print_error "Failed to install nvm. Moving on.."
        return 1
    fi
    execute "nvm install --lts" "Installing latest LTS node version"

    # shellcheck source=/dev/null
    source "$HOME/.bashrc"

    # install js apps
    execute "npm i -g eslint" "Install eslint"
    execute "npm i -g prettier" "Install prettier"
}

install_apt() {
    PACKAGE="$1"
    PACKAGE_READABLE_NAME="$2"

    if ! package_is_installed "$PACKAGE" "apt"; then
        execute "yes | sudo apt-get install $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

install_snap() {
    PACKAGE="$1"
    PACKAGE_READABLE_NAME="$2"
    MORE="$3"

    if ! package_is_installed "$PACKAGE" "snap"; then
        execute "sudo snap install $PACKAGE $MORE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
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

add_ppts() {
    # golang
    yes | sudo add-apt-repository ppa:longsleep/golang-backports

    # chrome
    # wget -q -O -- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    # sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"

    # docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # neovim
    yes | sudo add-apt-repository ppa:neovim-ppa/stable

    # pop os theme
    yes | sudo apt-add-repository ppa:system76/pop

    sudo apt-get update
}

install_kitty() {
    print_info "Kitty Terminal"

    if cmd_exists "kitty"; then
        print_success "Kitty Terminal"
        return 0
    fi

    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    # set as default
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator \
        "$HOME/.local/kitty.app/bin/kitty" 50
    sudo update-alternatives --set x-terminal-emulator "$HOME/.local/kitty.app/bin/kitty"
    return 0
}

install_bat() {
    print_info "bat"

    if cmd_exists "bat"; then
        print_success "bat"
        return 0
    fi

    curl -LO https://github.com/sharkdp/bat/releases/download/v0.11.0/bat_0.11.0_amd64.deb
    sudo apt install ./bat_0.11.0_amd64.deb
    if [ "$#" -eq 0 ]; then
        rm ./bat_0.11.0_amd64.deb
        return 0
    fi
    return 1
}

install_fdfind() {
    print_info "fd"

    if cmd_exists "fd"; then
        print_success "fd"
        return 0
    fi

    curl -LO https://github.com/sharkdp/fd/releases/download/v7.3.0/fd_7.3.0_amd64.deb
    sudo dpkg -i fd_7.3.0_amd64.deb
    if [ "$#" -eq 0 ]; then
        rm ./fd_7.3.0_amd64.deb
        return 0
    fi
    return 1

}

install_ripgrep() {
    print_info "RipGrep"

    if cmd_exists "rg"; then
        print_success "RipGrep"
        return 0
    fi

    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
    sudo dpkg -i ripgrep_11.0.2_amd64.deb
    if [ "$#" -eq 0 ]; then
        rm ./ripgrep_11.0.2_amd64.deb
        return 0
    fi
    return 1
}

install_hub() {
    execute "go get -u github.com/github/hub" "hub"
}

install_apps() {
    add_ppts

    print_info "Installing APT/Snap apps"

    # apt
    install_apt stow "GNU Stow"
    install_apt fonts-firacode "FiraCode font"
    install_apt neovim "Neovim"
    install_apt golang-go "Golang"
    install_apt snapd "Snapd"
    install_apt pass "pass"
    install_apt jq "jq"
    install_apt shellcheck "shellcheck"
    install_apt docker-ce "docker"
    install_apt docker-ce-cli "docker cli"
    install_apt containerd.io "containerd runtime"
    install_apt google-chrome-stable "Chrome"
    install_apt firefox "Firefox"
    install_apt tor "TOR"
    install_apt qbittorrent "QBitTorrent"
    install_apt vlc "VLC"
    install_apt gnome-tweaks "GNOME Tweaks"
    install_apt chrome-gnome-shell "Chrome GNOME shell"
    install_apt imagemagick "ImageMagick"

    # snaps
    install_snap spotify "Spotify"
    install_snap shfmt "shfmt"
    install_snap snap-store "Snap Store"

    # not on apt apps
    install_hub
    install_kitty
    install_bat
    install_fdfind
    install_ripgrep
}

configure_ui() {
    install_apt pop-theme "Pop OS! Theme"
    gsettings set org.gnome.shell.extensions.user-theme name 'Pop-dark-slim'
    gsettings set org.gnome.desktop.interface icon-theme 'Pop'
    gsettings set org.gnome.desktop.interface gtk-theme 'Pop-slim-dark'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface text-scaling-factor 0.9
    gsettings set org.gnome.desktop.interface font-name 'Sans 11'
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/ellison/Pictures/pathfinder.jpg'
    gsettings set org.gnome.desktop.background picture-uri 'file:///home/ellison/Pictures/pathfinder3.jpg'
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    verify_os

    ask_for_sudo

    clone_dotfiles

    install_apps

    configure_terminal

    configure_python

    configure_node

    configure_ui

    print_in_green "Success! Please restart the terminal to see the changes!"
}

main
