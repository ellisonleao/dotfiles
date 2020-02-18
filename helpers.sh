#!/bin/bash

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------
print_in_green() {
    printf "\\e[0;32m%s\\e[0m\\n" "$1"
}

print_in_purple() {
    printf "\\e[0;35m%s\\e[0m\\n" "$1"
}

print_in_red() {
    printf "\\e[0;31m%s\\e[0m\\n" "$1"
}

print_error() {
    print_in_red "  [✖] $1 $2"
}

print_info() {
    print_in_purple "$1"
}

print_result() {
    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"
}

print_success() {
    print_in_green "  [✔] $1"
}

ask_for_sudo() {

    # Ask for the administrator password upfront
    sudo -v &>/dev/null

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &>/dev/null &

}

verify_os() {
    if [ ! "$(uname -s)" == "Linux" ]; then
        echo "Sorry, this script is intended only for Ubuntu based distros!"
        exit 1
    fi
}

show_spinner() {

    local -r FRAMES='/-\|'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frameText=""

    # Display spinner while the commands are being executed.

    while kill -0 "$PID" &>/dev/null; do

        frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
        # Print frame text.
        printf "%s" "$frameText"
        sleep 0.2

        # Clear frame text.
        printf "\\r"

    done

}

set_trap() {
    trap -p "$1" | grep "$2" &>/dev/null ||
        trap '$2' "$1"

}

execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # Execute commands in background

    eval "$CMDS" \
        &>/dev/null \
        2>"$TMP_FILE" &

    cmdsPID=$!

    # Show a spinner if the commands
    # require more time to complete.
    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &>/dev/null
    exitCode=$?

    # Print output based on what happened.

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream <"$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"
    return $exitCode

}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

cmd_exists() {
    command -v "$1" &>/dev/null
    return $?
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
