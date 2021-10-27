#!/bin/bash
# editor
alias vim=~/.local/neovim/build/bin/nvim
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

# github
alias issues="gh issue"

# copy and move files interactive
alias cp='cp -i'
alias mv='mv -i'

# untar
alias untar='tar xvf'

# modern command replacements
alias cat='bat --theme=ansi -p'
alias less='bat -p'
alias grep='rg'
alias find='fd'
alias hexdump='hx'
alias time='hyperfine'
alias du='dust'
alias top='btm'
alias iftop='sudo ~/.cargo/bin/bandwhich'
alias ls="ls --color=auto"
alias la="ls -lahF"

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# weather
alias weather="curl http://wttr.in/Curitiba?0F1qn"

# human to unixtime format
alias tounixtime="python -c \"import time,datetime,sys;print(time.mktime(datetime.datetime.strptime(sys.argv[1], '%d-%m-%Y').timetuple()));\""

# http server
alias httpserver="python -m http.server"

# youtube-dl
alias dl="youtube-dl --socket-timeout=2"

alias xclip="xclip -se c"

# file permission in octec value
alias perm='stat -c "%a %n"'

# dolar/euro to brl latest quotation
alias dollar="rates usd brl"
alias euro="rates eur brl"

# to wifi issues
alias restart-wifi="nmcli radio wifi off && nmcli radio wifi on"

# damn abnt2!
alias fixkb="setxkbmap -model abnt2 -layout br"

# terminal pastebin
alias tb="nc termbin.com 9999"

# shellcheck source=/dev/null
[[ -f "$HOME/.dockerfunc" ]] && source "$HOME/.dockerfunc"

# phone
function phone() {
    adb tcpip 5555
    adb connect 192.168.68.101:5555
    scrcpy &
}

function jira() {
  if [[ $# -eq 0 ]]; then
    echo "project missing"
    return
  fi

  local project="$1"
  local branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ -z $branch ]]; then
    echo "branch not found"
    return
  fi

  xdg-open "https://${1}.atlassian.net/browse/${branch}"
}
