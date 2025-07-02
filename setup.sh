#!/bin/bash
# setup.sh - Add Bash Enhancer sourcing to your ~/.bashrc if not already present

ENHANCER_SNIPPET='if [ -f "$HOME/.bash_enhancer/bash_enhancer.sh" ]; then
    . "$HOME/.bash_enhancer/bash_enhancer.sh"
else
    echo "Warning: $HOME/.bash_enhancer/bash_enhancer.sh not found." >&2
    echo "You can reinstall from: https://github.com/huszakricsi/bash_enhancer" >&2
fi'

BASHRC="$HOME/.bashrc"

# Check if the snippet is already in .bashrc
if grep -Fq '.bash_enhancer/bash_enhancer.sh' "$BASHRC"; then
    echo "Bash Enhancer is already set up in $BASHRC."
else
    echo -e "\n# Bash Enhancer\n$ENHANCER_SNIPPET" >> "$BASHRC"
    echo "Bash Enhancer setup added to $BASHRC."
    echo
    echo "To activate Bash Enhancer in your current shell, run:"
    echo "  source \"$BASHRC\""
    echo "Or open a new terminal window."
    echo -e "\nUse 'h' command to see the list of aliases and functions."
fi
