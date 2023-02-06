#!/usr/bin/env bash

WORKSPACE_DIR="$HOME/hook-development"
INSTALATION_DIR="/usr/local/hook"

echo "

Welcome to the Hook Language Development Container!

This Docker container is set up for you to work on the Hook project.

The development workspace is at $WORKSPACE_DIR, which it's mounted over 
a folder on your real machine (host) to share files. And the environment 
variables PATH, HOOK_WORKSPACE and HOOK_HOME are set up.

Useful resources can be found at $HOME, 
$WORKSPACE_DIR and $INSTALATION_DIR.
Feel free to check them out and modify them to your liking.

Enjoy your coding and let's make Hook awesome together!

"