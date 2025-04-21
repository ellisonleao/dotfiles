#!/bin/bash
# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Enable aliases to be sudo’ed
alias sudo='sudo '

# git
alias gco="git commit"
alias gp="git pull"
alias gpu="git push"
alias gsy="hub sync"

# github
alias issues="gh issue"

# copy and move files interactive
alias cp='cp -i'
alias mv='mv -i'

# untar
alias untar='tar xvf'

# modern command replacements
alias cat='bat -p --theme=gruvbox-dark'
alias grep='rg'
alias find='fd'
alias du='dust'
alias iftop='sudo bandwhich'
alias ls="ls --color=auto"
alias la="ls -lahF"

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlan0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# weather
alias weather="curl http://wttr.in/Curitiba?0F1qn"

# human to unixtime format
alias tounixtime="python -c \"import time,datetime,sys;print(time.mktime(datetime.datetime.strptime(sys.argv[1], '%d-%m-%Y').timetuple()));\""

# http server
alias httpserver="python -m http.server"
alias http="http -s default --verify=no"

# youtube-dl
alias dl="yt-dlp"

alias xclip="xclip -se c"

# file permission in octec value
alias perm='stat -c "%a %n"'

# to wifi issues
function restart-wifi() {
        sudo systemctl restart NetworkManager
}

# terminal pastebin
alias tb="nc termbin.com 9999"

# shellcheck source=/dev/null
[[ -f "$HOME/.dockerfunc" ]] && source "$HOME/.dockerfunc"

# python venv
# shellcheck source=/dev/null
function activate() {
        [[ -f ".venv/bin/activate" ]] && source ".venv/bin/activate"
        [[ -f "venv/bin/activate" ]] && source "venv/bin/activate"
}

function new-venv() {
        uv venv --python="$1"
        activate
        uv pip install django-types djangorestframework-types
        [[ -f "./requirements-dev.txt" ]] && uv pip install -r requirements-dev.txt
}

[[ -f "$HOME/.work_aliases" ]] && source "$HOME/.work_aliases"

function update-nvim() {
        target=${1:-nightly}
        tmp_bin=/tmp/nvim.appimage.${target}
        previous=$(nvim --version | grep '^NVIM')
        url="https://github.com/neovim/neovim/releases/download/${target}/nvim-linux-x86_64.appimage"
        echo "[update-nvim] target version  ${target}"
        echo "[update-nvim] current version ${previous}"
        echo "[update-nvim] downloading file ${url}"
        curl --output "${tmp_bin}" --silent -L "${url}"
        file_type=$(file "${tmp_bin}")
        if [[ $file_type =~ .*executable.* ]]; then
                mv "${tmp_bin}" ~/.local/bin/nvim
                chmod +x ~/.local/bin/nvim
                current=$(nvim --version | grep '^NVIM')
                echo "[update-nvim] installed version ${current}"
        else
                echo "[update-nvim] Invalid file ${file_type}; exiting"
                return 1
        fi
}

# editor
alias vim=~/.local/bin/nvim
alias v=vim
alias vi=vim

# k3s
[[ -f "/etc/rancher/k3s/k3s.yaml" ]] && alias k3ctl='kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml'
