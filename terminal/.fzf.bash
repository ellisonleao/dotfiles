# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ellison/.local/share/nvim/site/pack/packer/start/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/ellison/.local/share/nvim/site/pack/packer/start/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ellison/.local/share/nvim/site/pack/packer/start/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/ellison/.local/share/nvim/site/pack/packer/start/fzf/shell/key-bindings.bash"
