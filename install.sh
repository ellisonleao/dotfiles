#!/bin/bash

# shellcheck source=/dev/null
source ./helpers.sh

# --------------------------------------------------------------------
# | Main Functions                                                   |
# --------------------------------------------------------------------


create_folders() {
    mkdir -p ~/.local/bin
    mkdir -p ~/.local/share/applications
}

configure_terminal() {
    print_info "Configuring terminal"
    FOLDERS="base16 bash git nvim python kitty gnupg ui prettier"
    for item in $FOLDERS; do
        execute "stow ${item}" "Creating ${item} symlink"
    done
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

configure_scala() {
    print_info "Configuring Scala"

    # sbt deb
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

    # installing requirements
    install_apt default-jdk "JDK"
    install_apt sbt "SBT"

    # install metals-vim
    METALS_VERSION=0.7.6
    curl -L -o ~/.local/bin/coursier https://git.io/coursier && chmod +x ~/.local/bin/coursier
    ~/.local/bin/coursier bootstrap \
      --java-opt -Xss4m \
      --java-opt -Xms100m \
      --java-opt -Dmetals.client=coc.nvim \
      org.scalameta:metals_2.12:$METALS_VERSION \
      -r bintray:scalacenter/releases \
      -r sonatype:snapshots \
      -o ~/.local/bin/metals-vim -f

    # install ammonite repl
    sudo sh -c '(echo "#!/usr/bin/env sh" && curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.7.1/2.13-1.7.1) > ~/.local/bin/scala && chmod +x ~/.local/bin/scala'
}

configure_keys() {
    print_info "Keybase + pass"
    install_apt pass "Pass"
    for folder in "$HOME/.ssh" "$HOME/.password-store"; do
        if [ -d "$folder" ]; then
            echo "Removing $folder .."
            rm -r "$folder"
        fi
    done
    # download keybase
    curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
    sudo apt install ./keybase_amd64.deb
    rm keybase_amd64.deb

    # login
    keybase login

    # import private keys
    keybase pgp export -s | gpg --allow-secret-key-import --import -

    git clone keybase://private/ellison/ssh ~/.ssh
    chmod 0400 ~/.ssh/id_rsa
    ssh-add

    # import password store
    git clone keybase://private/ellison/vault ~/.password-store
}


install_browserpass() {
    RELEASE="browserpass-linux64"
    FILE="$RELEASE-3.0.6.tar.gz"
    # dowload release
    pushd "$HOME/.local" || exit
        curl -LO "https://github.com/browserpass/browserpass-native/releases/download/3.0.6/$FILE"
        # extract and make the executabe into the path
        tar xvf $FILE
        rm $FILE
    popd

    pushd $RELEASE || exit
        make BIN=$RELEASE configure
        sudo make BIN=$RELEASE install
        sudo make BIN=$RELEASE hosts-brave-user
    popd
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

    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

    # add desktop integration
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications
    sed -i "s/Icon\=kitty/Icon\=\/home\/$USER\/.local\/kitty.app\/share\/icons\/hicolor\/256x256\/apps\/kitty.png/g" ~/.local/share/applications/kitty.desktop

    # set as default
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$HOME/.local/kitty.app/bin/kitty" 50
    sudo update-alternatives --set x-terminal-emulator "$HOME/.local/kitty.app/bin/kitty"

    # update desktop icon list
    update-desktop-database "$HOME/.local/share/applications"
}

install_neovim() {
    print_info "Neovim"
    VERSION="v0.4.2"
    pushd "$HOME/.local" || exit
        curl -LO "https://github.com/neovim/neovim/releases/download/$VERSION/nvim-linux64.tar.gz"
        tar xvf nvim-linux64.tar.gz
        rm nvim-linux64.tar.gz
    popd
    ln -s "$HOME/.local/nvim-linux64/bin/nvim" "$HOME/.local/bin"
    ln -s "$HOME/.local/nvim-linux64/share/applications/nvim.desktop" "$HOME/.local/share/applications"
    sed -i "s/Icon\=nvim/Icon\=\/home\/$USER\/.local\/nvim-linux64\/share\/pixmaps\/nvim.png/g" "$HOME/.local/share/applications/nvim.desktop"
    update-desktop-database "$HOME/.local/share/applications"
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

install_starship() {
    pushd "$HOME/.local" || exit
        curl -LO https://github.com/starship/starship/releases/download/v0.17.0/starship-v0.17.0-x86_64-unknown-linux-gnu.tar.gz
        tar xvf starship-v0.17.0-x86_64-unknown-linux-gnu.tar.gz
        mv x86_64-unknown-linux-gnu starship
    popd
    ln -s "$HOME/.local/starship/starship" "$HOME/.local/bin"
}

install_apps() {
    add_ppts

    print_info "Installing APT/Snap apps"

    # apt
    install_apt git "Git"
    install_apt stow "GNU Stow"
    install_apt fonts-firacode "FiraCode font"
    install_apt neovim "Neovim"
    install_apt golang-go "Golang"
    install_apt snapd "Snapd"
    install_apt jq "jq"
    install_apt fd-find "fd"
    install_apt ripgrep "ripgrep"
    install_apt shellcheck "shellcheck"
    install_apt docker-ce "docker"
    install_apt docker-ce-cli "docker cli"
    install_apt containerd.io "containerd runtime"
    install_apt firefox "Firefox"
    install_apt tor "TOR"
    install_apt qbittorrent "QBitTorrent"
    install_apt vlc "VLC"
    install_apt gnome-tweaks "GNOME Tweaks"
    install_apt chrome-gnome-shell "Chrome GNOME shell"
    install_apt imagemagick "ImageMagick"
    install_apt dconf-editor "dconf-editor"

    # snaps
    install_snap spotify "Spotify"
    install_snap shfmt "shfmt"
    install_snap snap-store "Snap Store"

    # not on apt apps
    install_kitty
    install_neovim
    install_bat
    install_browserpass
    install_starship
}

configure_ui() {
    install_apt pop-theme "Pop OS! Theme"
    gsettings set org.gnome.desktop.interface icon-theme 'Pop'
    gsettings set org.gnome.desktop.interface gtk-theme 'Pop-slim-dark'
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface text-scaling-factor 0.9
    gsettings set org.gnome.desktop.interface font-name 'Sans 11'
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Sans 13'
    gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/ellison/Pictures/pathfinder.jpg'
    gsettings set org.gnome.desktop.background picture-uri 'file:///home/ellison/Pictures/pathfinder3.jpg'
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    verify_os

    ask_for_sudo

    configure_keys

    install_apps

    configure_terminal

    configure_python

    configure_node

    configure_scala

    configure_ui

    print_in_green "Success! Please restart the terminal to see the changes!"
}

main
