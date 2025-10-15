#!/bin/bash
# ✨ Pre-commit Hook for Design System ✨
# 💻 Credit: Tornike Bardadze

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

echo -e "${BLUE}🔧 Pre-commit hook triggered!${NC}"

SWIFTLINT_BIN="/opt/homebrew/bin/swiftlint"
SWIFTFORMAT_BIN="/opt/homebrew/bin/swiftformat"

# ----------------------------
# Check if SwiftLint exists
# ----------------------------
if [ ! -f "$SWIFTLINT_BIN" ]; then
    echo -e "${RED}❌ SwiftLint not installed.${NC} Install via Homebrew: ${YELLOW}brew install swiftlint${NC}"
    exit 1
fi

# ----------------------------
# Check if SwiftFormat exists
# ----------------------------
if [ ! -f "$SWIFTFORMAT_BIN" ]; then
    echo -e "${RED}❌ SwiftFormat not installed.${NC} Install via Homebrew: ${YELLOW}brew install swiftformat${NC}"
    exit 1
fi

# ----------------------------
# Get staged Swift files
# ----------------------------
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

if [ -z "$STAGED_FILES" ]; then
    echo -e "${YELLOW}⚠️  No Swift files staged. Skipping SwiftLint & SwiftFormat.${NC}"
    exit 0
fi

PASS=true

# ----------------------------
# Create temp dir for staged files
# ----------------------------
TMP_DIR=$(mktemp -d)

for FILE in $STAGED_FILES; do
    mkdir -p "$TMP_DIR/$(dirname "$FILE")"
    git show ":$FILE" > "$TMP_DIR/$FILE"
done

# ----------------------------
# Run SwiftLint on staged files
# ----------------------------
cd "$TMP_DIR" || exit 1
echo -e "${BLUE}🔍 Running SwiftLint...${NC}"
"$SWIFTLINT_BIN" lint --strict
if [ $? -ne 0 ]; then
    PASS=false
fi
cd - >/dev/null || exit 1

# ----------------------------
# Run SwiftFormat on staged files (sort imports + format)
# ----------------------------
echo -e "${BLUE}🧹 Running SwiftFormat on staged files...${NC}"
for FILE in $STAGED_FILES; do
    "$SWIFTFORMAT_BIN" "$FILE" --enable sortImports --swiftversion 5
    git add "$FILE"
done

# ----------------------------
# Clean up
# ----------------------------
rm -rf "$TMP_DIR"

# ----------------------------
# Show result
# ----------------------------
if ! $PASS; then
    echo -e "${RED}❌ SwiftLint violations detected. Commit aborted.${NC}"
    exit 1
else
    echo -e "${GREEN}🎉 SwiftLint passed & imports sorted! Commit ready.${NC}"
fi

exit 0
