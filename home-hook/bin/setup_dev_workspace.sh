#!/usr/bin/env bash

WORKSPACE_DIR="$HOME/hook-development"
WORKSPACE_GIT_DIR="$WORKSPACE_DIR/.git"
INSTALATION_DIR="/usr/local/hook"
PROJECT_URL="https://github.com/fabiosvm/hook-lang.git"
BUILD_SCRIPT="./scripts/build-and-install.sh"
TEST_SCRIPT="./scripts/test.sh"
BASHRC_D="$HOME/.bashrc.d"
SETUP_DEV_SCRIPT="setup_dev_workspace.sh"
SETUP_DEV_SCRIPT_LINK="$(find "$BASHRC_D" -name "*$SETUP_DEV_SCRIPT" 2>/dev/null)"
GREETINGS_SCRIPT_AFTER_SETUP="$HOME/.bashrc.d/111-greetings.sh"
GREETINGS="


Welcome to the Hook Language Development Workspace!

We're excited to get started with the Hook language project!

This first time, we'll clone the Hook language repository to 
'$WORKSPACE_DIR', build, and install it with the build type 'Release' 
and option 'with-no-extension'. After that, tests will run automatically.

The installation directory is '$INSTALATION_DIR'.

Please note that this script will only run on the first start. Next time, 
you'll see a message indicating that the workspace is set up and ready for 
you to work on the Hook language project.

Get ready to code and have fun with Hook!
"

if [ -d "$WORKSPACE_GIT_DIR" ]; then
    if [ -f "$SETUP_DEV_SCRIPT_LINK" ]; then
        rm "$SETUP_DEV_SCRIPT_LINK" ||
            echo "Warning: Removing the setup_dev_workspace.sh script from the .bashrc.d folder failed"
    fi
    chmod +x "$GREETINGS_SCRIPT_AFTER_SETUP" ||
        echo "Warning: Changing the permissions of the 111-greetings.sh script at the .bashrc.d folder failed"
else
    echo "$GREETINGS"

    ASK_TO_PROCEED="Would you like to proceed with Hook workspace setup? (y/n) "
    read -p "$ASK_TO_PROCEED" PROCEED

    while [ "$PROCEED" != "y" ] && [ "$PROCEED" != "Y" ]; do
        clear
        echo "$GREETINGS"
        read -p "$ASK_TO_PROCEED" PROCEED
    done

    echo "

Setting up the Hook workspace..."

    if [ -f "$SETUP_DEV_SCRIPT_LINK" ]; then
        echo "Removing this script itself from the .bashrc.d folder"
        rm "$SETUP_DEV_SCRIPT_LINK" ||
            echo "Warning: Removing the setup_dev_workspace.sh script from the .bashrc.d folder failed"
        chmod -x "$GREETINGS_SCRIPT_AFTER_SETUP" ||
            echo "Warning: Changing the permissions of the 111-greetings.sh script at the .bashrc.d folder failed"
    fi

    if ! git clone "$PROJECT_URL" "$WORKSPACE_DIR"; then
        echo "Error: Cloning the hook-lang repository failed"
        exit 1
    fi

    if ! cd "$WORKSPACE_DIR"; then
        echo "Error: Entering the workspace dir $WORKSPACE_DIR failed"
        exit 1
    fi

    echo "
Building and installing hook application with the following parameters:
    Build type: Release
    Build options: with-no-extension
    Install directory: $INSTALATION_DIR"

    if ! "$BUILD_SCRIPT" "Release" "with-no-extension" "$INSTALATION_DIR"; then
        echo "Error: Building and installing hook application failed"
        exit 1
    fi

    echo "Running hook tests..."

    if ! "$TEST_SCRIPT"; then
        echo "Error: Hook tests failed"
        exit 1
    fi
fi

exit 0
