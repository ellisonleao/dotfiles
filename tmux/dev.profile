#!/bin/bash
tmux kill-session -t dev
tmux start-server;

  cd /Users/ellison/Code/sg

  # Create the session and the first window. Manually switch to root
  # directory if required to support tmux < 1.9
  TMUX= tmux new-session -d -s dev -n editor
  tmux send-keys -t dev:1 cd\ /Users/ellison/Code/sg C-m


  # Window "editor"
  tmux send-keys -t dev:1.1 cd\ \~/Code/sg/ C-m

  tmux splitw -c /Users/ellison/Code/sg -t dev:1
  tmux splitw -t dev:1
  # custom window size for my 15" notebook
  tmux select-layout -t dev:1 c59e,178x48,0,0\{109x48,0,0,0,68x48,110,0\[68x23,110,0,1,68x24,110,24,2\]\}

  tmux select-window -t 1
  tmux select-pane -t 0

  if [ -z "$TMUX" ]; then
    tmux -u attach-session -t dev
  else
    tmux -u switch-client -t dev
  fi


