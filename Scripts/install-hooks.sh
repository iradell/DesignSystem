#!/bin/bash
# 🌟 Installer for the pre-commit hook 🌟
# 💻 Credit: Tornike Bardadze

# 🔍 Resolve project root
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
HOOK_FILE="$HOOKS_DIR/pre-commit"
SOURCE_HOOK="$PROJECT_ROOT/Scripts/pre-commit.sh"

# ⚠️ Check source hook exists
if [ ! -f "$SOURCE_HOOK" ]; then
    echo "❌ Error: $SOURCE_HOOK not found."
    exit 1
fi

# 📂 Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# 📋 Copy pre-commit hook into .git/hooks
cp "$SOURCE_HOOK" "$HOOK_FILE"

# 🔧 Make it executable
chmod +x "$HOOK_FILE"

# ✅ Success message
echo "🎉 Pre-commit hook installed successfully at $HOOK_FILE"
