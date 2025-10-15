#!/bin/bash
HOOKS_DIR=".git/hooks"
HOOK_FILE="$HOOKS_DIR/pre-commit"

echo "Installing pre-commit hook..."
mkdir -p "$HOOKS_DIR"
cp Scripts/pre-commit.sh "$HOOK_FILE"
chmod +x "$HOOK_FILE"
echo "Pre-commit hook installed!"

