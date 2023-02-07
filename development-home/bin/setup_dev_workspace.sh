#!/usr/bin/env bash

WORKSPACE_DIR="$HOME/hook-development"
WORKSPACE_GIT_DIR="$WORKSPACE_DIR/.git"
INSTALATION_DIR="/usr/local/hook"
# TODO Add a parameter to set the repository URL to the user fork
PROJECT_URL="https://github.com/fabiosvm/hook-lang.git"
BUILD_SCRIPT="./scripts/build-and-install.sh"
TEST_SCRIPT="./scripts/test.sh"
MSG_GIT_DIR_EXISTS_EXITING="
The Hook Language has already been cloned to '$WORKSPACE_DIR'.
Exiting... "

if [ -d "$WORKSPACE_GIT_DIR" ]; then
    echo "$MSG_GIT_DIR_EXISTS_EXITING"
    exit 0
fi

echo "

Setting up the Hook workspace..."

if ! sudo chown -R "$USER:users" "$WORKSPACE_DIR" &&
    sudo chmod -R 777 "$WORKSPACE_DIR"; then
    echo "Error: Changing the ownership and permissions of the workspace dir $WORKSPACE_DIR failed"
    exit 1
fi
sudo chown -R "$USER:users" "$WORKSPACE_DIR" &&
    sudo chmod -R 777 "$WORKSPACE_DIR"

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

if ! sudo "$BUILD_SCRIPT" "Release" "with-no-extension" "$INSTALATION_DIR"; then
    echo "Error: Building and installing hook application failed"
    exit 1
fi

echo "Running hook tests..."

if ! "$TEST_SCRIPT"; then
    echo "Error: Hook tests failed"
    exit 1
fi