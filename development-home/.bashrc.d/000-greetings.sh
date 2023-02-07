#!/usr/bin/env bash

WORKSPACE_DIR="$HOME/hook-development"
WORKSPACE_GIT_DIR="$WORKSPACE_DIR/.git"
INSTALATION_DIR="/usr/local/hook"
SETUP_DEV_SCRIPT="setup_dev_workspace.sh"
MSG_ASK_TO_PROCEED="Would you like to proceed with Hook workspace setup? (y/n) "
MSG_GREETINGS="
Welcome to the Hook Language Development Container!

We're excited to get started with the Hook language project!

This first time, we'll clone the Hook language repository to
'$WORKSPACE_DIR', build, and install it with the build type 'Release'
and option 'with-no-extension'. After that, tests will run automatically.

The installation directory is '$INSTALATION_DIR'.

Please note that this script will only run on the first start. Next time,
you'll see a message indicating that the workspace is set up and ready for
you to work on the Hook language project.

Mount the development folder at '$WORKSPACE_DIR' to your host 
system with 'docker run --volume' to access it and avoid losing changes 
when stopping the container.

Get ready to code and have fun with Hook!

"
MSG_GREETINGS_AFTER_SETUP="

Welcome to the Hook Language Development Container!

This Docker container is set up for you to work on the Hook project.

The development workspace is at $WORKSPACE_DIR, which it's mounted over 
a folder on your real machine (host) to share files. And the environment 
variables PATH, HOOK_WORKSPACE and HOOK_HOME are set up.

Useful resources can be found at $HOME, 
$WORKSPACE_DIR and $INSTALATION_DIR.
Feel free to check them out and modify them to your liking.

Mount the development folder at '$WORKSPACE_DIR' to your host 
system with 'docker run --volume' to access it and avoid losing changes 
when stopping the container.

Enjoy your coding and let's make Hook awesome together!

"

if [ -d "$WORKSPACE_GIT_DIR" ]; then
    echo "$MSG_GREETINGS_AFTER_SETUP"
else
    echo "$MSG_GREETINGS"

    read -p "$MSG_ASK_TO_PROCEED" PROCEED

    while [ "$PROCEED" != "y" ] && [ "$PROCEED" != "Y" ]; do
        clear
        echo "$MSG_GREETINGS"
        read -p "$MSG_ASK_TO_PROCEED" PROCEED
    done

    if ! "$SETUP_DEV_SCRIPT"; then
        echo "Error: The Hook workspace setup script failed"
        exit 1
    fi
fi