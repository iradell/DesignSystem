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
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

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

PASS=true

# ----------------------------
# Run SwiftLint on entire project
# ----------------------------
echo -e "${BLUE}🔍 Running SwiftLint on the whole project...${NC}"
"$SWIFTLINT_BIN" lint --strict --config "$PROJECT_ROOT/.swiftlint.yml" "$PROJECT_ROOT"
if [ $? -ne 0 ]; then
    PASS=false
fi

# ----------------------------
# Run SwiftFormat on entire project (sort imports + format)
# ----------------------------
echo -e "${BLUE}🧹 Running SwiftFormat on the whole project...${NC}"
"$SWIFTFORMAT_BIN" "$PROJECT_ROOT" --enable sortImports --swiftversion 5

# Stage all files after formatting
git add .

# ----------------------------
# Show result
# ----------------------------
if ! $PASS; then
    echo -e "${RED}❌ SwiftLint violations detected. Commit aborted.${NC}"
    exit 1
else
    echo -e "${GREEN}🎉 SwiftLint passed & imports sorted for the whole project! Commit ready.${NC}"
fi

exit 0
