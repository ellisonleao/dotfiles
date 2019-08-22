#!/bin/bash

if [ ! -f "$HOME/.profile" ]; then
    # shellcheck source=/dev/null
    source "$HOME/.bashrc"
else
    # shellcheck source=/dev/null
    source "$HOME/.profile"
fi
