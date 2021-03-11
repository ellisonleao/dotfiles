#!/bin/bash
# editor
alias vim=~/.local/bin/nvim
alias vi=vim
alias v=vim

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Enable aliases to be sudo’ed
alias sudo='sudo '

# virtualenvwrapper
alias w=workon

# git
alias git=hub
alias gs="git sync"
function gitignore() {
    ARGS=$*
    curl -sL "https://www.gitignore.io/api/${ARGS}"
}
alias gig=gitignore

# copy and move files interactive
alias cp='cp -i'
alias mv='mv -i'

# untar
alias untar='tar xvf'

# startgrid
# shellcheck source=/dev/null
[ -f "$HOME/.ssh/startgrid/aliases" ] && source "$HOME/.ssh/startgrid/aliases"

# modern command replacements
alias cat='bat -p'
alias less='bat -p'
alias grep='rg'
alias find='fd'
alias hexdump='hx'
alias time='hyperfine'
alias du='dust'
alias top='btm'
alias iftop='sudo ~/.cargo/bin/bandwhich'
alias ls="ls --color=auto"
alias la="ls -laF"

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# weather
alias weather="curl http://wttr.in/Curitiba?0F1qn"

# unixtime to human format
alias tounixtime="python -c \"import time,datetime,sys;print(time.mktime(datetime.datetime.strptime(sys.argv[1], '%d-%m-%Y').timetuple()));\""

# http server
alias httpserver="python -m http.server"

# youtube-dl
alias dl="youtube-dl --socket-timeout=2"

alias xclip="xclip -se c"

# file permission in octec value
alias perm='stat -c "%a %n"'

# shellcheck source=/dev/null
[[ -f "$HOME/.dockerfunc" ]] && source "$HOME/.dockerfunc"

# dolar/euro to brl latest quotation
alias dollar="rates usd brl"
alias euro="rates eur brl"


function skey() {
    local geometry=$(slop -n -f '%g')
    screenkey -s large --bg-color green -t 1 --opacity 0.5 -g "${geometry}"
}

# youtube-dl clip
download-clip() {
    # $1: url or Youtube video id
    # $2: starting time, in seconds, or in hh:mm:ss[.xxx] form
    # $3: duration, in seconds, or in hh:mm:ss[.xxx] form
    # $4: format, as accepted by youtube-dl (default: best)
    local fmt=${4:-best}
    youtube-dl -f "$fmt" "$1" --postprocessor-args "-ss ${2} -to ${3}" --socket-timeout=2
}

alias https="http --verify=no"
alias restart-wifi="nmcli radio wifi off && nmcli radio wifi on"

alias fixkb="setxkbmap -model abnt2 -layout br"

get-neovim() {
    local folder="$HOME/.local"
    local filename="nvim-linux64.tar.gz"
    local url="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"

    pushd "$folder"
    wget -q "$url"
    untar "$filename"
    ln -fs "$folder/nvim-linux64/bin/nvim" "$folder/bin"
    rm "$filename"
    popd

    echo "NeoVIM updated to latest master"
}

colors() {
    for i in {0..255}; do
        printf "\x1b[38;5;%smcolour%s\x1b[0m\n" "$i" "$i"
    done
}

license() {
    local key=$1
    local url="https://api.github.com/licenses/${key}"
    local JQ
    JQ=$(command -v jq)
    res=$(curl -s "$url" | $JQ .body?)

    echo "${res}"
}
