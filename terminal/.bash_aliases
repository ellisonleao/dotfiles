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
alias find='fdfind'
alias ps='procs'
alias hexdump='hx'
alias time='hyperfine'
alias du='dust'
alias top='ytop'
alias iftop='sudo ~/.cargo/bin/bandwhich'
alias ls="exa"
alias la="ls -laF"

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\\? \\(addr:\\)\\?\\s\\?\\(\\(\\([0-9]\\+\\.\\)\\{3\\}[0-9]\\+\\)\\|[a-fA-F0-9:]\\+\\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\\: .*|GET \\/.*\""

# weather
alias weather="curl http://wttr.in/Curitiba?0F1qn"

# unixtime to human format
alias humandate="python -c \"import datetime,sys;print(datetime.datetime.utcfromtimestamp(int(sys.argv[1][:10])).strftime('%d/%m/%Y @ %H:%M:%S'));\""
alias tounixtime="python -c \"import time,datetime,sys;print(time.mktime(datetime.datetime.strptime(sys.argv[1], '%d-%m-%Y').timetuple()));\""

# icat alias
alias icat="kitty +kitten icat"

# http server
alias httpserver="python -m http.server"

# youtube-dl
alias dl="annie"

alias xclip="xclip -se c"

# file permission in octec value
alias perm='stat -c "%a %n"'

# shellcheck source=/dev/null
[[ -f "$HOME/.dockerfunc" ]] && source "$HOME/.dockerfunc"

# dolar/euro to brl latest quotation
alias dollar="curl -s 'https://api.cotacoes.uol.com/currency/intraday/list?currency=1&fields=bidvalue,date' | jq .docs[0].bidvalue"
alias euro="curl -s 'https://api.cotacoes.uol.com/currency/intraday/list?currency=5&fields=bidvalue,date' | jq .docs[0].bidvalue"
