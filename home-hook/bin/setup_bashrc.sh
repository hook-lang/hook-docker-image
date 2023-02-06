#!/usr/bin/env bash

BASHRC_DIR="$HOME/.bashrc.d"
BASHRC_FILE="$HOME/.bashrc"

# The command to be added to the .bashrc file to run the scripts at the .bashrc.d folder
BASHRC_NEW_COMMAND="

# Run the scripts at the $BASHRC_DIR folder
BASHRC_DIR=\"$BASHRC_DIR\"
cd \"\$BASHRC_DIR\"
for SCRIPT in \$(ls -v ./); do
    if [ -r \"\$SCRIPT\" ] && [ -x \"\$SCRIPT\" ]; then
        ./\"\$SCRIPT\"
    fi
done"

echo "$BASHRC_NEW_COMMAND" >> "$BASHRC_FILE"