# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ellison/.local/share/nvim/plugged/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/ellison/.local/share/nvim/plugged/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ellison/.local/share/nvim/plugged/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/ellison/.local/share/nvim/plugged/fzf/shell/key-bindings.bash"
