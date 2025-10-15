#!/bin/bash
# ✨ SwiftLint Pre-commit Hook ✨
# 💻 Credit: Tornike Bardadze

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

echo -e "${BLUE}🔧 Pre-commit hook triggered!${NC}"

SWIFTLINT_BIN="/opt/homebrew/bin/swiftlint"

# ⚠️ Check SwiftLint exists
if [ ! -f "$SWIFTLINT_BIN" ]; then
    echo -e "${RED}❌ SwiftLint not installed.${NC} Install via Homebrew: ${YELLOW}brew install swiftlint${NC}"
    exit 1
fi

# 📄 Get all staged Swift files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

if [ -z "$STAGED_FILES" ]; then
    echo -e "${YELLOW}⚠️  No Swift files staged. Skipping SwiftLint.${NC}"
    exit 0
fi

PASS=true

# 🗂 Create temporary directory for staged versions of files
TMP_DIR=$(mktemp -d)

# 💾 Copy staged files to temporary directory
for FILE in $STAGED_FILES; do
    mkdir -p "$TMP_DIR/$(dirname "$FILE")"
    git show ":$FILE" > "$TMP_DIR/$FILE"
done

# 🚀 Run SwiftLint on staged files
cd "$TMP_DIR" || exit 1
echo -e "${BLUE}🔍 Running SwiftLint...${NC}"
"$SWIFTLINT_BIN" lint --strict
if [ $? -ne 0 ]; then
    PASS=false
fi
cd - >/dev/null || exit 1

# 🧹 Clean up
rm -rf "$TMP_DIR"

# ✅ Show result
if ! $PASS; then
    echo -e "${RED}❌ SwiftLint violations detected. Commit aborted.${NC}"
    exit 1
else
    echo -e "${GREEN}🎉 SwiftLint passed! You may proceed with commit.${NC}"
fi

exit 0
